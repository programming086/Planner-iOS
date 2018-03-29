
import Foundation
import CoreData
import UIKit

// класс для работы с БД
class Db{

    var context:NSManagedObjectContext! // контекст для связи объектов с БД

    init() {

        // используем AppDelegate для получения доступа к контексту
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                fatalError("appdelegate error")
        }

        // получаем контекст из persistentContainer
        context = appDelegate.persistentContainer.viewContext

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

    // добавить новую категорию
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

    // добавить новый приоритет
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


    // добавить новую задачу
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

    func deleteTask(task:Task){
        // удалить задачу из БД
        context.delete(task)

        do {
            try context.save() // сохраняем изменений
        } catch let error as NSError {
            print("Could not save. \(error)")
        }
    }


    // нужно запускать только 1 раз
    func initData() {
        // добавляем категорию
        let cat1 = addCategory(name: "Спорт")
        let cat2 = addCategory(name: "Семья")
        let cat3 = addCategory(name: "Отдых")
        let cat4 = addCategory(name: "Бизнес")
        let cat5 = addCategory(name: "Здоровье")
        let cat6 = addCategory(name: "Личное")

        // добавляем категорию
        let priority1 = addPriority(name: "Низкий", index:1)
        let priority2 = addPriority(name: "Нормальный", index:2)
        let priority3 = addPriority(name: "Высокий", index:3)


        // добавляем задачу с категорием (и пустым приоритетом)
        let task1 = addTask(name: "Сходить в бассейн", completed: false, deadline: Date().rewindDays(15), info: "доп. инфо", category: cat1, priority: priority1)
        let task2 = addTask(name: "Выезд на природу", completed: false, deadline: Date().rewindDays(-10), info: "", category: cat3, priority: priority3)
        let task3 = addTask(name: "Вынести мусор", completed: false, deadline: Date().rewindDays(25), info: "", category: cat6, priority: priority3)
        let task4 = addTask(name: "Купить продукты", completed: false, deadline: Date().rewindDays(1), info: "доп. инфо", category: cat2, priority: priority1)
        let task5 = addTask(name: "Помыть машину", completed: false, deadline: Date().today, info: "", category: cat2, priority: priority1)

        let task6 = addTask(name: "Сделать ремонт", completed: false, deadline: Date().rewindDays(10), info: "", category: cat1, priority: priority1)

        let task7 = addTask(name: "Отвезти в садик", completed: false, deadline: Date().today, info: "", category: cat3, priority: priority3)

        let task8 = addTask(name: "Футбольный матч", completed: false, deadline: Date().today, info: "", category: cat5, priority: priority2)

        let task9 = addTask(name: "Купить подарки", completed: false, deadline: Date().today, info: "", category: cat4, priority: priority1)

        let task10 = addTask(name: "Помыть машину", completed: false, deadline: Date().today, info: "", category: cat6, priority: priority2)


    }



}
