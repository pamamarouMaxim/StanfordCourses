//
//  SelectThemeTableViewController.swift
//  StanfordProgect
//
//  Created by Maxim Panamarou on 10/1/18.
//  Copyright © 2018 Maxim Panamarou. All rights reserved.
//

import UIKit

class SelectThemeTableViewController: UITableViewController, UISplitViewControllerDelegate {

    private static var identifier = "ChooseGameSegue"
  
    private var themes = GameTheme.CurrentTheme.allCases
  
    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
  
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
  
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = themes[indexPath.row].rawValue
        return cell
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let cell = tableView.cellForRow(at: indexPath)
      if let cvc = splitViewDetailConcentrationViewController {
          cvc.theme = GameTheme.CurrentTheme(rawValue: (cell?.textLabel?.text)!)
      } else if let cvc = lastSeguedToConcentrationViewController {
          cvc.theme = GameTheme.CurrentTheme(rawValue: (cell?.textLabel?.text)!)
          navigationController?.pushViewController(cvc, animated: true)
      } else {
          performSegue(withIdentifier: SelectThemeTableViewController.identifier, sender: cell)
      }
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let identifier = segue.identifier, identifier == SelectThemeTableViewController.identifier, let cvc = segue.destination as? ConcentrationViewController {
        if let cell = sender as? UITableViewCell {
          cvc.theme = GameTheme.CurrentTheme(rawValue: (cell.textLabel?.text)!)
          lastSeguedToConcentrationViewController = cvc
        }
      }
    }
  
  func splitViewController(_ splitViewController: UISplitViewController,
                           collapseSecondary secondaryViewController: UIViewController,
                           onto primaryViewController: UIViewController
    ) -> Bool
  {
    if let cvc = secondaryViewController as? ConcentrationViewController {
      return cvc.currentGame.gameTheme.themeName  == nil
    }
    return false
  }
  
}
