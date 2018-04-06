//
//  ViewController.swift
//  SWIFT41JsonDecoder
//
//  Created by SHANI SHAH on 06/04/18.
//  Copyright © 2018 SHANI SHAH. All rights reserved.
// https://api.letsbuildthatapp.com/jsondecodable/courses_snake_case

import UIKit
import Alamofire

struct Course: Decodable {
    let id: Int
    let name: String
    let link: String
    let numberOfLessons: Int
    let imageUrl: String
}

class ViewController: UIViewController {

    @IBOutlet weak var courseTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Course List"
        fetchJSON()
        courseTableView.delegate = self
        courseTableView.dataSource = self
        
    }
    
    var courses = [Course]()
    
    

    func fetchJSON()  {
        let urlString = "https://api.letsbuildthatapp.com/jsondecodable/courses_snake_case"
        guard let url = URL(string: urlString) else {
            return
        }
        print(url)
        
        Alamofire.request(url).responseData { (responseData) in
            guard let data = responseData.data else {return}

            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                self.courses = try decoder.decode([Course].self, from: data)
                OperationQueue.main.addOperation {
                    self.courseTableView.reloadData()
                }
            } catch let jsonError{
                print("failed to decode",jsonError)
            }
        }
    }
   

}
extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courses.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let course = self.courses[indexPath.row]
        cell.textLabel?.text = "\(course.name)"
        cell.detailTextLabel?.text = "\(course.numberOfLessons)"
        Alamofire.request(course.imageUrl).responseData { (responseData) in
            cell.imageView?.image = UIImage(data: responseData.data!)
        }
        return cell
    }
}

