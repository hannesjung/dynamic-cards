//
//  ViewController.swift
//  Test
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var cardCollectionView: UICollectionView!
	@IBOutlet weak var cardsHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var pageControl: UIPageControl!
	
	private let cardHeights: [CGFloat] = [250, 350, 300, 200, 400]
	
	private var currentContentOffset: CGFloat = 0
	private var currentPage: Int = 0 { didSet { currentIndexPath = IndexPath(item: currentPage, section: 0) } }
	private var nextPage: Int = 0 { didSet { nextIndexPath = IndexPath(item: nextPage, section: 0) } }
	
	private var currentIndexPath = IndexPath(item: 0, section: 0)
	private var nextIndexPath = IndexPath(item: 0, section: 0)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		pageControl.numberOfPages = cardHeights.count
		updateCardHeight(animated: false)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		updateCardHeight(animated: false)
	}
	
	// MARK: - Card height
	
	private func updateCardHeight(animated: Bool = true) {
		guard let currentHeight: CGFloat = cardCollectionView.layoutAttributesForItem(at: currentIndexPath)?.frame.height,
			let nextHeight: CGFloat = cardCollectionView.layoutAttributesForItem(at: nextIndexPath)?.frame.height
			else { return }
		let height = max(currentHeight, nextHeight)
		
		guard cardsHeightConstraint.constant != height else { return }
		cardsHeightConstraint.constant = height
		
		UIView.animate(withDuration: animated ? 0.5 : 0.0, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
			self.view.layoutIfNeeded()
		}, completion: nil)
	}
	
}

extension ViewController: UIScrollViewDelegate {
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		let o = scrollView.contentOffset.x
		currentContentOffset = o
		currentPage = Int(round(o / scrollView.bounds.width))
		nextPage = currentPage
		updateCardHeight()
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let o = scrollView.contentOffset.x
		let direction = currentContentOffset - o > 0 ? -1 : 1
		nextPage = currentPage + direction
		updateCardHeight()
		
		// Page
		pageControl.currentPage = Int(round(o / scrollView.bounds.width))
	}
	
}

extension ViewController: UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return cardHeights.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
		cell.set(height: cardHeights[indexPath.row])
		return cell
	}
	
}

class CardCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var contentWidthConstraint: NSLayoutConstraint!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		contentWidthConstraint.constant = UIScreen.main.bounds.width - 20
		self.layoutIfNeeded()
	}
	
	func set(height: CGFloat) {
		contentHeightConstraint.constant = height
		self.layoutIfNeeded()
	}
	
}
