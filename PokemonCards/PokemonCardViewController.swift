//
//  ViewController.swift
//  PokemonCards
//
//  Created by Erman Ufuk Demirci on 6.09.2022.
//

import UIKit

class PokemonCardViewController: UIViewController {
    
    private var cardTrigger = true
    
    private var currentPokemon: Pokemon?
    private var pokemonNumber = 1
    
    private var cardView: UIView!
    private var pokemonImageView: UIImageView!
    private var pokemonNameLabel: UILabel!
    private var pokemonStackView: UIStackView!

    private var pokemonCardButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray2

        fetchPokemon(of: pokemonNumber)
        loadCard()
    }
    
    // MARK: - CARD Manipulation
    
    @objc private func pokemonCardTapped() {
        rotateCard()
        pokemonNumber += 1
        
        updateCardInfo()
        
        fetchPokemon(of: pokemonNumber)
    }
    
    private func updateCardInfo() {
        
        guard let currentPokemon = currentPokemon else {
            return
        }
        
        pokemonStackView.arrangedSubviews.forEach { view in
            pokemonStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        pokemonNameLabel.text = currentPokemon.name.uppercased()
        loadImage(from: currentPokemon.sprites.frontDefault)
        
        let hp = currentPokemon.stats[0].baseStat
        let attack = currentPokemon.stats[1].baseStat
        let defense = currentPokemon.stats[2].baseStat
        
        pokemonStackView.addArrangedSubview(makeStatView(key: "HP", value: hp))
        pokemonStackView.addArrangedSubview(makeStatView(key: "Attack", value: attack))
        pokemonStackView.addArrangedSubview(makeStatView(key: "Defense", value: defense))

    }
    
    private func makeStatView(key: String, value: Int) -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = key

        let statLabel = UILabel()
        statLabel.text = String(value)
        

        let vStackView = UIStackView(arrangedSubviews: [titleLabel, statLabel])
        vStackView.axis = .vertical
        vStackView.alignment = .center

        return vStackView
    }
    
    private func loadImage(from urlString: String){
        guard let url = URL(string: urlString) else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        
        pokemonImageView.image = UIImage(data: data)
    }
    
    // MARK: - API - Fetch
    
    private func fetchPokemon(of pokemonNumber: Int) {
        var urlString = "https://pokeapi.co/api/v2/pokemon/"
        urlString += "\(String(pokemonNumber))"
        performRequest(from: urlString)
    }

    private func performRequest(from urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)

            let task = session.dataTask(with: url, completionHandler: handle)
            task.resume()
        }
    }
    
    private func handle(data: Data?, response: URLResponse?, error: Error?) {
        if let safeData = data {
            parseJSON(pokemonData: safeData)
        }
    }
    
    private func parseJSON(pokemonData: Data) {
        do {
            let decodedData = try JSONDecoder().decode(Pokemon.self, from: pokemonData)
            currentPokemon = decodedData
        } catch {
        }
    }
    
    // MARK: - CARD - UI
    
    private func rotateCard() {
        if cardTrigger {
            UIView.transition(with: cardView,
                              duration: 0.5,
                              options: .transitionFlipFromBottom,
                              animations: nil)
        } else {
            UIView.transition(with: cardView,
                              duration: 0.5,
                              options: .transitionFlipFromRight,
                              animations: nil)
        }
        cardTrigger = !cardTrigger
    }
    
    private func loadCard() {
        
        cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.layer.cornerRadius = 25
        cardView.backgroundColor = .white
        view.addSubview(cardView)
        
        pokemonCardButton = UIButton()
        pokemonCardButton.translatesAutoresizingMaskIntoConstraints = false
        pokemonCardButton.layer.cornerRadius = 25
        pokemonCardButton.setTitleColor(.black, for: .normal)
        view.addSubview(pokemonCardButton)
        
        pokemonImageView = UIImageView()
        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
        pokemonImageView.contentMode = .scaleAspectFit
        pokemonImageView.image = UIImage(named: "PokemonLogo")
        cardView.addSubview(pokemonImageView)
        
        pokemonNameLabel = UILabel()
        pokemonNameLabel.translatesAutoresizingMaskIntoConstraints = false
        pokemonNameLabel.textAlignment = .center
        cardView.addSubview(pokemonNameLabel)
        
        pokemonStackView = UIStackView()
        pokemonStackView.translatesAutoresizingMaskIntoConstraints = false
        pokemonStackView.axis = .horizontal
        pokemonStackView.distribution = .equalCentering
        pokemonStackView.alignment = .center
        cardView.addSubview(pokemonStackView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            cardView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),

            pokemonCardButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            pokemonCardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokemonCardButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            pokemonCardButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            pokemonImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 125),
            pokemonImageView.heightAnchor.constraint(equalTo: cardView.heightAnchor, multiplier: 0.4),
            pokemonImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 30),
            pokemonImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -30),
            
            pokemonNameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 40),
            pokemonNameLabel.heightAnchor.constraint(equalToConstant: 50),
            pokemonNameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 30),
            pokemonNameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -30),
            
            pokemonStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
            pokemonStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            pokemonStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            pokemonStackView.heightAnchor.constraint(equalToConstant: 100),
            
            
        ])
        
        pokemonCardButton.addTarget(self, action: #selector(pokemonCardTapped), for: .touchUpInside)
    }
}
