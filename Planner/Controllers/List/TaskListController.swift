
import UIKit
import CoreData

class TaskListController: UITableViewController {

    let dateFormatter = DateFormatter()

    var taskList:[Task]! // коллекция, которая будет заполняться из БД

    var context:NSManagedObjectContext! // контекст для связи объектов с БД

    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
//
//        // симулятор загрузки формы (чтобы успеть посмотреть launchscreen) - в рабочем проекте естественно нужно будет удалить
//        for i in 0...200000 {
//            print(i)
//        }

        // используем AppDelegate для получения доступа к контексту
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                fatalError("appdelegate error")
        }

        // получаем контекст из persistentContainer
        context = appDelegate.persistentContainer.viewContext

        initData()// запускаем только 1 раз для заполнения таблиц

        taskList = getAllTasks()


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // нужно запускать только 1 раз
    func initData() {
        // добавляем категорию
        let cat1 = addCategory(name: "Спорт")
        let cat2 = addCategory(name: "Семья")
        let cat3 = addCategory(name: "Отдых")

        // добавляем категорию
        let priority1 = addPriority(name: "Низкий", index:1)
        let priority2 = addPriority(name: "Нормальный", index:2)
        let priority3 = addPriority(name: "Высокий", index:3)


        // добавляем задачу с категорием (и пустым приоритетом)
        let task1 = addTask(name: "Сходить в бассейн", completed: false, deadline: Date(), info: "доп. инфо", category: cat1, priority: priority1)
        let task2 = addTask(name: "Выезд на природу", completed: false, deadline: Date(), info: "", category: cat3, priority: priority3)
        let task3 = addTask(name: "Вынести мусор", completed: false, deadline: Date(), info: "", category: cat1, priority: priority3)
        let task4 = addTask(name: "Купить продукты", completed: false, deadline: Date(), info: "доп. инфо", category: cat2, priority: priority1)
        let task5 = addTask(name: "Помыть машину", completed: false, deadline: Date(), info: "", category: cat2, priority: priority1)

    }


    // получает все задачи из таблицы
    func getAllTasks() -> [Task] {

        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest() // подготовка контейнера для выборки данных

        let list:[Task]

        do {
             list = try context.fetch(fetchRequest) // выборка данных
        } catch {
            fatalError("Fetching Failed")
        }

        return list

    }

    func addCategory(name:String) -> Category{

        let category = Category(context: context) // указываем контекст для объекта

        category.name = name

        do {
            try context.save() // сохраняем каждый новый объект
        } catch let error as NSError {
            print("Could not save. \(error)")
        }

        return category // возвращаем созданную категорию
    }

    func addPriority(name:String, index: Int32) -> Priority{

        let priority = Priority(context: context) // указываем контекст для объекта

        priority.name = name
        priority.index = index

        do {
            try context.save() // сохраняем каждый новый объект
        } catch let error as NSError {
            print("Could not save. \(error)")
        }

        return priority // возвращаем созданный приоритет
    }


    func addTask(name:String, completed:Bool, deadline:Date?, info:String?, category:Category?, priority:Priority?) -> Task{ // опциональные типы необязательно передавать

        let task = Task(context: context) // указываем контекст для объекта

        task.name = name
        task.completed = completed
        task.deadline = deadline
        task.info = info
        task.category = category
        task.priority = priority

        do {
            try context.save() // сохраняем каждый новый объект
        } catch let error as NSError {
            print("Could not save. \(error)")
        }

        return task // возвращаем созданную задачу
    }




    // MARK: tableView

    // методы вызываются автоматически компонентом tableView

    // сколько секций нужно отображать в таблице
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // сколько будет записей в каждой секции
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }



    // отображение данных в строке
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath) as? TaskListCell else{
            fatalError("cell type")
        }

        let task = taskList[indexPath.row]

        cell.labelTaskName.text = task.name
        cell.labelTaskCategory.text = (task.category?.name ?? "")


        // проверяем дату на пустоту
        if let deadline = task.deadline{
            cell.labelDeadline?.text = dateFormatter.string(from: deadline)
        }else {
            cell.labelDeadline?.text =  ""
        }

        return cell
    }




    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
