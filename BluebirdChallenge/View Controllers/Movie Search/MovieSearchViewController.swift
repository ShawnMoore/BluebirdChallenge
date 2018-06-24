//
//  MovieSearchViewController.swift
//  BluebirdChallenge
//
//  Created by Shawn Moore on 6/23/18.
//  Copyright © 2018 Shawn Moore. All rights reserved.
//

import UIKit

class MovieSearchViewController: UIViewController {

    @IBOutlet weak var LoadingView: UIView?
    @IBOutlet weak var LoadingIndicator: UIActivityIndicatorView?
    
    fileprivate(set) var movieList: [MovieListRespone] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MovieSearchViewController: UITableViewDelegate & UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
