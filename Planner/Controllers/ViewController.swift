
import UIKit

class ViewController: UIViewController {

    // вызывается после инициализации
    override func viewDidLoad() {
        super.viewDidLoad()

        // симулятор загрузки формы (чтобы успеть посмотреть launchscreen) - в рабочем проекте естественно нужно будет удалить
        for i in 0...100000 {
            print(i)
        }
    }

    // вызывается, если не хватает памяти (чтобы очистить ресурсы)
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

