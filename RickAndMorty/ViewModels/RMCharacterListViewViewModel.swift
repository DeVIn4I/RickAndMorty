//
//  RMCharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Razumov Pavel on 22.04.2025.
//

import UIKit

protocol RMCharacterListVoewViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didSelectCharacet(_ character: RMCharacter)
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath])
}

final class RMCharacterListViewViewModel: NSObject {
    
    private var characters: [RMCharacter] = [] {
        didSet {
            for character in characters {
                let viewModel = RMCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image)
                )
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []
    private var apiInfo: RMGetAllCharactersResponse.Info?
    private var isLoadMoreCharacters: Bool = false
    
    public weak var delegate: RMCharacterListVoewViewModelDelegate?
    
    ///  Fetch initial set of characters(20)
    public func fetchCharacters() {
        RMService.shared.execute(
            .listCharactersRequest,
            expecting: RMGetAllCharactersResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                self?.characters = results
                self?.apiInfo = info
                
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        apiInfo?.next != nil
    }
    
    public func fetchAdditionalCharacters(url: URL) {
        guard !isLoadMoreCharacters else { return }
        
        isLoadMoreCharacters = true
        guard let request = RMRequest(url: url) else {
            isLoadMoreCharacters = false
            return
        }
        
        RMService.shared.execute(
            request,
            expecting: RMGetAllCharactersResponse.self) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    let originalCount = characters.count
                    let newCount = moreResults.count
                    let total = originalCount + newCount
                    let startingIndex = total - newCount
                    let indexPathsToAdd: [IndexPath] = Array(
                        startingIndex..<(startingIndex + newCount)
                    ).compactMap {
                        IndexPath(row: $0, section: 0)
                    }
                    apiInfo = info
                    characters.append(contentsOf: moreResults)
                    DispatchQueue.main.async {
                        self.delegate?.didLoadMoreCharacters(with: indexPathsToAdd)
                        self.isLoadMoreCharacters = false
                    }
                   
                case .failure(let failure):
                    print(String(describing: failure))
                    isLoadMoreCharacters = false
                }
            }
    }
}

extension RMCharacterListViewViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? RMCharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }
}

extension RMCharacterListViewViewModel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectCharacet(character)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard
            kind == UICollectionView.elementKindSectionFooter,
            shouldShowLoadMoreIndicator,
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
                for: indexPath
            ) as? RMFooterLoadingCollectionReusableView
        else {
            return UICollectionReusableView()
        }
        
        footer.statrtAnimating()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

extension RMCharacterListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard
            shouldShowLoadMoreIndicator,
            !isLoadMoreCharacters,
            !cellViewModels.isEmpty,
            let nextUrlString = apiInfo?.next,
            let url = URL(string: nextUrlString)
        else { return }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] timer in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 100) {
                self?.fetchAdditionalCharacters(url: url)
            }
            timer.invalidate()
        }
    }
}
