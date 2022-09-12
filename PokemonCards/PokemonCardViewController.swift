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
    
    private var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.backgroundColor = .white
        
        return view
    }()
    private var pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "PokemonLogo")
        
        return imageView
    }()
    private var pokemonNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    private var pokemonStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.alignment = .center
        
        return stack
    }()
    private var pokemonCardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray2

        loadCard()
        fetchPokemon()
    }
        
    // MARK: - Get Pokemon
    
    private func fetchPokemon() {

        APICaller.shared.getPokemon { decodedPokemon in
            switch decodedPokemon {
            case .success(let model):
                self.currentPokemon = model
            case .failure(_):
                break
            }
        }
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        guard let data = try? Data(contentsOf: url) else { return }

        self.pokemonImageView.image = UIImage(data: data)
    }
    
    // MARK: - PokemonCard and UI
    
    @objc private func pokemonCardTapped() {
       
        fetchPokemon()
        updateCardInfo()
        rotateCard()
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
        view.addSubview(cardView)
        cardView.addSubview(pokemonImageView)
        cardView.addSubview(pokemonNameLabel)
        cardView.addSubview(pokemonStackView)
        view.addSubview(pokemonCardButton)
        
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
