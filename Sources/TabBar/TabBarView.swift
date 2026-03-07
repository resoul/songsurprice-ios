import UIKit

public final class TabBarView: UIView {

    // MARK: - Public

    public weak var delegate: TabBarDelegate?

    public var collapsedHeight: CGFloat { config.mainRowHeight }
    public var expandedHeight: CGFloat  { config.mainRowHeight + config.genreRowHeight }

    // MARK: - Private state

    private var config: TabBarConfiguration
    private var selectedIndex: Int = 0
    private var selectedGenreIndex: Int? = nil
    private var tabButtons: [TabButton] = []
    private var genreButtons: [GenreButton] = []

    // MARK: - UI

    private let mainRow: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let tabStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 6
        sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private lazy var searchButton: SearchButton = {
        let b = SearchButton(config: config, searchTitle: searchTitle)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    private lazy var settingsButton: SettingsButton = {
        let b = SettingsButton(config: config)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    private let separator: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let genreRow: UIView = {
        let v = UIView()
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let genreScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let genreStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 6
        sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let genreSeparator: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private var genreRowHeightConstraint: NSLayoutConstraint!

    private let searchTitle: String

    // MARK: - Init

    public init(configuration: TabBarConfiguration, searchTitle: String = "Поиск") {
        self.config = configuration
        self.searchTitle = searchTitle
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        buildLayout()
        applyConfig()
        buildTabs()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Public API

    public func apply(configuration: TabBarConfiguration) {
        self.config = configuration
        applyConfig()
        buildTabs()
    }

    public func selectItem(id: String) {
        guard let index = config.items.firstIndex(where: { $0.id == id }) else { return }
        activateTab(at: index)
    }

    // MARK: - Focus

    override public var preferredFocusEnvironments: [UIFocusEnvironment] {
        tabButtons.first.map { [$0] } ?? []
    }

    public func lockSettingsFocus() {
        settingsButton.canFocusAfterDismiss = false
    }

    public func unlockSettingsFocus() {
        settingsButton.applyFocusAppearance(focused: false)
        settingsButton.canFocusAfterDismiss = true
    }

    // MARK: - Layout

    private func buildLayout() {
        addSubview(mainRow)
        addSubview(genreRow)
        addSubview(separator)

        mainRow.addSubview(tabStack)
        mainRow.addSubview(settingsButton)
        mainRow.addSubview(searchButton)

        genreRow.addSubview(genreScrollView)
        genreScrollView.addSubview(genreStack)
        genreRow.addSubview(genreSeparator)

        genreRowHeightConstraint = genreRow.heightAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            mainRow.topAnchor.constraint(equalTo: topAnchor),
            mainRow.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainRow.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainRow.heightAnchor.constraint(equalToConstant: config.mainRowHeight),

            settingsButton.leadingAnchor.constraint(equalTo: mainRow.leadingAnchor, constant: 24),
            settingsButton.centerYAnchor.constraint(equalTo: mainRow.centerYAnchor),

            tabStack.leadingAnchor.constraint(equalTo: settingsButton.trailingAnchor, constant: 20),
            tabStack.centerYAnchor.constraint(equalTo: mainRow.centerYAnchor),

            searchButton.trailingAnchor.constraint(equalTo: mainRow.trailingAnchor, constant: -24),
            searchButton.centerYAnchor.constraint(equalTo: mainRow.centerYAnchor),

            genreRow.topAnchor.constraint(equalTo: mainRow.bottomAnchor),
            genreRow.leadingAnchor.constraint(equalTo: leadingAnchor),
            genreRow.trailingAnchor.constraint(equalTo: trailingAnchor),
            genreRowHeightConstraint,

            genreScrollView.topAnchor.constraint(equalTo: genreRow.topAnchor),
            genreScrollView.leadingAnchor.constraint(equalTo: genreRow.leadingAnchor),
            genreScrollView.trailingAnchor.constraint(equalTo: genreRow.trailingAnchor),
            genreScrollView.bottomAnchor.constraint(equalTo: genreRow.bottomAnchor),

            genreStack.topAnchor.constraint(equalTo: genreScrollView.topAnchor),
            genreStack.leadingAnchor.constraint(equalTo: genreScrollView.leadingAnchor, constant: 72),
            genreStack.trailingAnchor.constraint(equalTo: genreScrollView.trailingAnchor, constant: -72),
            genreStack.bottomAnchor.constraint(equalTo: genreScrollView.bottomAnchor),
            genreStack.heightAnchor.constraint(equalTo: genreScrollView.heightAnchor),

            genreSeparator.leadingAnchor.constraint(equalTo: genreRow.leadingAnchor),
            genreSeparator.trailingAnchor.constraint(equalTo: genreRow.trailingAnchor),
            genreSeparator.bottomAnchor.constraint(equalTo: genreRow.bottomAnchor),
            genreSeparator.heightAnchor.constraint(equalToConstant: 1),

            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
        ])

        searchButton.onSelect   = { [weak self] in guard let s = self else { return }; s.delegate?.tabBarDidSelectSearch(s) }
        settingsButton.onSelect = { [weak self] in guard let s = self else { return }; s.delegate?.tabBarDidSelectSettings(s) }
    }

    private func applyConfig() {
        separator.backgroundColor    = config.separatorColor
        genreSeparator.backgroundColor = config.separatorColor
    }

    // MARK: - Build tabs from config

    private func buildTabs() {
        tabStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        tabButtons.removeAll()
        selectedIndex = 0

        for (i, item) in config.items.enumerated() {
            let btn = TabButton(item: item, config: config)
            btn.isActiveTab = (i == 0)
            let index = i
            btn.onSelect = { [weak self] in self?.handleTabTap(at: index) }
            tabStack.addArrangedSubview(btn)
            tabButtons.append(btn)
        }

        if let first = config.items.first {
            showGenres(first.genres, animated: false)
        }
    }

    // MARK: - Tab interaction

    private func handleTabTap(at index: Int) {
        if index == selectedIndex {
            deselectGenre()
            delegate?.tabBar(self, didSelectItem: config.items[index])
            return
        }
        activateTab(at: index)
        delegate?.tabBar(self, didSelectItem: config.items[index])
    }

    private func activateTab(at index: Int) {
        guard index < config.items.count else { return }
        tabButtons[safe: selectedIndex]?.isActiveTab = false
        selectedIndex = index
        tabButtons[safe: index]?.isActiveTab = true
        showGenres(config.items[index].genres, animated: true)
    }

    // MARK: - Genre interaction

    private func showGenres(_ genres: [GenreItem], animated: Bool) {
        selectedGenreIndex = nil
        genreStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        genreButtons.removeAll()

        guard !genres.isEmpty else {
            setGenreRowVisible(false, animated: animated)
            return
        }

        for (i, genre) in genres.enumerated() {
            let btn = GenreButton(genre: genre, config: config)
            let index = i
            btn.onSelect = { [weak self] in self?.handleGenreTap(at: index) }
            genreStack.addArrangedSubview(btn)
            genreButtons.append(btn)
        }

        setGenreRowVisible(true, animated: animated)
        genreScrollView.setContentOffset(.zero, animated: false)
    }

    private func handleGenreTap(at index: Int) {
        if let prev = selectedGenreIndex { genreButtons[safe: prev]?.isActiveTab = false }
        selectedGenreIndex = index
        genreButtons[safe: index]?.isActiveTab = true
        let item = config.items[selectedIndex]
        let genre = item.genres[index]
        delegate?.tabBar(self, didSelectGenre: genre, inItem: item)
    }

    private func deselectGenre() {
        if let prev = selectedGenreIndex { genreButtons[safe: prev]?.isActiveTab = false }
        selectedGenreIndex = nil
    }

    private func setGenreRowVisible(_ visible: Bool, animated: Bool) {
        let targetH: CGFloat = visible ? config.genreRowHeight : 0
        guard genreRowHeightConstraint.constant != targetH else { return }
        genreRowHeightConstraint.constant = targetH
        if animated {
            UIView.animate(withDuration: 0.28, delay: 0,
                           usingSpringWithDamping: 0.85, initialSpringVelocity: 0) {
                self.superview?.layoutIfNeeded()
            }
        } else {
            superview?.layoutIfNeeded()
        }
    }
}

// MARK: - Array safe subscript

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
