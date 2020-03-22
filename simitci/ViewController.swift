//
//  ViewController.swift
//  simitci
//
//  Created by ercan on 15.01.2020.
//  Copyright © 2020 simitci. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher
import Alamofire

let delegate = UIApplication.shared.delegate as! AppDelegate

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    let context = delegate.persistentContainer.viewContext

    @IBOutlet weak var categoryView: UICollectionView!
    @IBOutlet weak var collectionViews: UICollectionView!
    
    var list = [Foods]()
    var categoryList = [Category]()
    var searchList = [Foods]()
    var isSearch = false
    var searchCategoryList = [Foods]()
    var isSelectCategory = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark
        
        addNavBarImage()
        loadProcut()
        
        collectionViews.delegate = self
        collectionViews.dataSource = self
        searchBar.delegate = self
        
        categoryView.delegate = self
        categoryView.dataSource = self
        
        
        
        if !UserDefaults.standard.bool(forKey: "isFirst"){
            self.isSelectCategory = false
            self.collectionViews.reloadData()
            DispatchQueue.main.async {
                self.getProduct(id: "0")
            }
            UserDefaults.standard.set(true, forKey: "isFirst")
        }
        

    }
    
    func addNavBarImage() {
        let navController = navigationController!
        let image = UIImage(named: "logo.jpeg")
        let imageView = UIImageView(image: image)
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        let bannerX = bannerWidth / 2 - (image?.size.width)! / 2
        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }

    
    
    @IBAction func refreshData(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Error", message:"Oops Something went wrong.Please check your internet connection", preferredStyle: .alert)
        let okeyAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        
        alertController.addAction(okeyAction)
        
        let status = NetworkReachabilityManager()?.isReachable ?? false
        
        if status {
            self.isSelectCategory = false
            self.collectionViews.reloadData()
            DispatchQueue.main.async {
                self.getProduct(id: "0")
            }
        }else{
            present(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func allData(_ sender: Any) {
        isSelectCategory = false
        collectionViews.reloadData()

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionViews.reloadItems(at: collectionViews.indexPathsForVisibleItems)
    }
    
}



extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViews{
            return CGSize(width: ((UIScreen.main.bounds.width - 157) / 2) - 10, height: ((UIScreen.main.bounds.width - 157) / 2) - 10)
        }else{
            return CGSize(width: 140, height: 147)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collectionViews{
            return isSearch ? searchList.count : isSelectCategory ? searchCategoryList.count : list.count
        }else{
            return categoryList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        if collectionView == collectionViews{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
            cell.layer.cornerRadius = 10
            
            if !isSearch{
                
                if isSelectCategory{
                    cell.name.text = searchCategoryList[indexPath.row].ad!.uppercased()
                    cell.fiyat.text = searchCategoryList[indexPath.row].fiyat! + " €"
                    cell.fiyat.textColor = .black
                    let resource = ImageResource(downloadURL: URL(string: searchCategoryList[indexPath.row].resim!)!, cacheKey: searchCategoryList[indexPath.row].resim!)
                    cell.image.kf.setImage(with: resource)
                }else{
                    cell.name.text = list[indexPath.row].ad!.uppercased()
                    cell.fiyat.text = list[indexPath.row].fiyat! + " €"
                    cell.fiyat.textColor = .black
                    let resource = ImageResource(downloadURL: URL(string: list[indexPath.row].resim!)!, cacheKey: list[indexPath.row].resim!)
                    cell.image.kf.setImage(with: resource)
                }
                
            }else{
                cell.name.text = searchList[indexPath.row].ad!.uppercased()
                cell.fiyat.text = searchList[indexPath.row].fiyat! + " €"
                cell.fiyat.textColor = .black
                let resource = ImageResource(downloadURL: URL(string: searchList[indexPath.row].resim!)!, cacheKey: searchList[indexPath.row].resim!)
                cell.image.kf.setImage(with: resource)
            }
            cell.fiyatView.layer.cornerRadius = 4
            return cell;
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "category", for: indexPath) as! CategoryCell
            cell.backgroundColor = .white
            cell.layer.cornerRadius = 20
            cell.layer.masksToBounds = false
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.3
            cell.layer.shadowOffset = CGSize(width: 1, height: 1)
            cell.name.text = categoryList[indexPath.row].ad!.uppercased()
            let resource = ImageResource(downloadURL: URL(string: categoryList[indexPath.row].resim!)!, cacheKey: categoryList[indexPath.row].resim!)
            cell.categoryImage.kf.setImage(with: resource)
            
            return cell
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionViews{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "detail") as! DetailViewController
            
            if !isSearch{
                if isSelectCategory{
                    let resource = ImageResource(downloadURL: URL(string: searchCategoryList[indexPath.row].resim!)!, cacheKey: searchCategoryList[indexPath.row].resim!)
                    vc.resource = resource
                }else{
                    let resource = ImageResource(downloadURL: URL(string: list[indexPath.row].resim!)!, cacheKey: list[indexPath.row].resim!)
                    vc.resource = resource
                }

            }else{
                let resource = ImageResource(downloadURL: URL(string: searchList[indexPath.row].resim!)!, cacheKey: searchList[indexPath.row].resim!)
                vc.resource = resource
            }
            
            if isSelectCategory{
                if isSearch{
                    vc.aciklama = searchList[indexPath.row].aciklama
                    vc.myFiyat = searchList[indexPath.row].fiyat
                    vc.myKategori = searchList[indexPath.row].kategori_ad?.uppercased()
                }else{
                    vc.aciklama = searchCategoryList[indexPath.row].aciklama
                    vc.myFiyat = searchCategoryList[indexPath.row].fiyat
                    vc.myKategori = searchCategoryList[indexPath.row].kategori_ad?.uppercased()
                }
            }else{
                if isSearch{
                    vc.aciklama = searchList[indexPath.row].aciklama
                    vc.myFiyat = searchList[indexPath.row].fiyat
                    vc.myKategori = searchList[indexPath.row].kategori_ad?.uppercased()
                }else{
                    vc.aciklama = list[indexPath.row].aciklama
                    vc.myFiyat = list[indexPath.row].fiyat
                    vc.myKategori = list[indexPath.row].kategori_ad?.uppercased()
                }

            }
            
            self.present(vc, animated: true, completion: nil)
        }else{
            isSelectCategory = true
            self.searchCategoryList = list.filter({$0.kategori == categoryList[indexPath.row].id})
            collectionViews.reloadData()
        }
        

    }

    
    

}

extension ViewController{
    
    func getProduct(id:String){
        myApi.shared.getData(kategoriID:id, completionHandler: { json in
            
            self.deleteAllData()
             self.list = []
             //self.collectionViews.reloadData()
                 
                 let liste = json.map({ mapData -> Foods in
                         
                     let foods = Foods(context: self.context)
                               
                         foods.ad = mapData.ad
                         foods.kategori = mapData.kategori
                         foods.kategori_ad = mapData.kategori_ad
                         foods.id = mapData.id
                         foods.fiyat = mapData.fiyat
                         foods.resim = mapData.resim
                         foods.aciklama = mapData.aciklama

                         return foods
                     })
             self.getCategory()

             self.list = liste
             delegate.saveContext()
            
             self.collectionViews.reloadData()
        })
    }
    
    func getCategory(){
        myApi.shared.getkategori(completionHandler: {categoryListe in
            self.categoryList = []
            self.categoryView.reloadData()
            
            let liste = categoryListe.map({ mapData-> Category  in
                
                let category = Category(context: self.context)
                
                    category.ad = mapData.ad
                    category.id = mapData.id
                    category.resim = mapData.resim
   

                    return category
                
            })
            
            self.categoryList = liste
            delegate.saveContext()
            self.categoryView.reloadData()
        })
    }
    
    func loadProcut(){
        let fetchRequest:NSFetchRequest<Foods> = Foods.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Foods.id), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        let categoryRequest:NSFetchRequest<Category> = Category.fetchRequest()
        let categorySort = NSSortDescriptor(key: #keyPath(Category.id), ascending: false)
        categoryRequest.sortDescriptors = [categorySort]
        
            
        do {
            self.list = try context.fetch(fetchRequest)
            self.categoryList = try context.fetch(categoryRequest)
            
            self.collectionViews.reloadData()
            self.categoryView.reloadData()
        } catch{
            print("Error Load")
        }
    }
    
    
    func deleteAllData() {
        do {
            let foods = try context.fetch(Foods.fetchRequest()) as! [Foods]
            let category = try context.fetch(Category.fetchRequest()) as! [Category]
            
            for object in foods{
                context.delete(object)
            }
            
            for object in category{
                context.delete(object)
            }
        
            delegate.saveContext()
        } catch{
            print("Delete All Data Error")
        }
    }
       
}

extension ViewController:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == ""{
            isSearch = false
        }else{
            isSearch = true
            if isSelectCategory{
                searchList = searchCategoryList.filter({($0.ad?.lowercased().contains(searchText.lowercased()))!})
            }else{
                searchList = list.filter({($0.ad?.lowercased().contains(searchText.lowercased()))!})
            }
        }
        self.collectionViews.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
    }
}
