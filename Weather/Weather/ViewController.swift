//
//  ViewController.swift
//  Weather
//
//  Created by Сергей Киров on 21.07.2023.
//

import Combine
import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    private let backgroundImageView = UIImageView()
    private let statusImageView = UIImageView()
    private let mainStackView = UIStackView()
    private let statusStackView = UIStackView()
    private let temperatureLabel = UILabel()
    private let cityLabel = UILabel()
    
    let viewModel = ViewModel()
    var cancellables = Set<AnyCancellable>()
    var weather: WeatherModel?
    
    //Implement closure in viewModel!!!!!!!!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel.getWeather()
        }
        setupUI()
        bindViewModel()
    }
    

    func bindViewModel() {
        viewModel.$weather
            .sink { [weak self] weather in
                self?.weather = weather
            }
            .store(in: &cancellables)
        
        viewModel.$state
            .sink { [weak self] state in
                switch state {
                case .none:
                    self?.viewModel.getWeather()
                case .loading:
                    print("Loading")
                    self?.statusImageView.image = UIImage(systemName:  "arrow.clockwise.icloud")
                    self?.temperatureLabel.attributedText = self?.attributedText(with: "...")
                    self?.cityLabel.text = "Loading weather"
                case .success:
                    Task {
                        self?.statusImageView.image = UIImage(systemName: self?.viewModel.getStatusImage() ?? "")
                        self?.temperatureLabel.attributedText = self?.attributedText(with: self?.viewModel.getTemperature() ?? "")
                        self?.cityLabel.text = self?.viewModel.getCity()
                        print(self?.weather)
                        
                    }
                    default:
                        return
                    }
                }
                    .store(in: &cancellables)
    }

}

// MARK: - Functions
extension ViewController {
    
    private func setupUI(){
        style()
        layout()
    }
    
    private func style(){
        //image style
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = #imageLiteral(resourceName: "background")
        
        //mainstack View
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.spacing = 10
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        
        //statusImageView style
        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        statusImageView.image = UIImage(systemName: "sun.max")
        statusImageView.tintColor = .label
        
        //temperatureLable style
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.font = UIFont.systemFont(ofSize: 80)
        temperatureLabel.attributedText = attributedText(with: "15")
        
        //cityLabel style
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.font = UIFont.systemFont(ofSize: 40)
//        cityLabel.text = "Saint-Petersburg"

    }
    
    private func configureProperties(){
        view.addSubview(backgroundImageView)
        view.addSubview(mainStackView)
    }
    
    private func configureStackView(){
        //MainStackView add item
        mainStackView.addArrangedSubview(statusImageView)
        mainStackView.addArrangedSubview(temperatureLabel)
        mainStackView.addArrangedSubview(cityLabel)
    }
    
    
    private func layout(){
        configureProperties()
        configureStackView()
        
        
        NSLayoutConstraint.activate([
            //backgroundImageView layout
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            //mainStackView layout
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            //statusImageView layout
            statusImageView.heightAnchor.constraint(equalToConstant: 150),
            statusImageView.widthAnchor.constraint(equalToConstant: 150),
            
        ])
    }
    
    
    private func attributedText(with text: String) -> NSMutableAttributedString{
        let attributedText = NSMutableAttributedString(string: text, attributes: [.foregroundColor : UIColor.label, .font: UIFont.boldSystemFont(ofSize: 90)])
        attributedText.append(NSAttributedString(string: "°C",attributes: [.font: UIFont.systemFont(ofSize: 50)]))
        return attributedText
    }
}
