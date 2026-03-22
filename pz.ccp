#include <iostream>
#include <string>
#include <iomanip>

using namespace std;

// ============================================================
// Базовый абстрактный класс: Строительная задача
// ============================================================
class BuildingTask {
protected:
    string taskName;        // наименование
    string responsible;     // ответственный
    int plannedDays;        // плановый срок (в днях)
    double completionPercent; // процент выполнения

public:
    // Конструктор с параметрами
    BuildingTask(string name, string resp, int days, double percent = 0.0) {
        taskName = name;
        responsible = resp;
        plannedDays = (days > 0) ? days : 1;
        completionPercent = (percent >= 0 && percent <= 100) ? percent : 0.0;
    }

    // Виртуальный деструктор
    virtual ~BuildingTask() {
        cout << "Задача \"" << taskName << "\" (" << getTaskType() 
             << ") удалена из системы." << endl;
    }

    // Геттеры (обычные методы)
    string getTaskName() const { return taskName; }
    string getResponsible() const { return responsible; }
    int getPlannedDays() const { return plannedDays; }
    double getCompletionPercent() const { return completionPercent; }

    // Обычный метод (общий для всех потомков, не переопределяется)
    void updateProgress(double percent) {
        if (percent >= 0 && percent <= 100) {
            completionPercent = percent;
            cout << "Прогресс задачи \"" << taskName 
                 << "\" обновлён: " << completionPercent << "%" << endl;
        } else {
            cout << "Некорректное значение прогресса. Допустимо 0-100%" << endl;
        }
    }

    // Чисто виртуальные функции
    virtual double estimateCost() = 0;           // расчёт стоимости работ
    virtual string getRiskLevel() = 0;           // оценка уровня риска задержки
    
    // Виртуальный метод вывода информации
    virtual void printInfo() {
        cout << "==========================================" << endl;
        cout << "Тип задачи:   " << getTaskType() << endl;
        cout << "Наименование: " << taskName << endl;
        cout << "Ответственный: " << responsible << endl;
        cout << "Плановый срок: " << plannedDays << " дн." << endl;
        cout << "Выполнено:    " << completionPercent << "%" << endl;
    }

protected:
    // Вспомогательный метод для получения типа задачи
    virtual string getTaskType() const {
        return "Строительная задача";
    }
};

// ============================================================
// Производный класс: Земляные работы
// ============================================================
class ExcavationTask : public BuildingTask {
private:
    double soilVolume;      // объём грунта в куб.м
    double depth;           // глубина в метрах

public:
    ExcavationTask(string name, string resp, int days, double percent,
                   double volume, double depthVal)
        : BuildingTask(name, resp, days, percent) {
        soilVolume = (volume > 0) ? volume : 0;
        depth = (depthVal > 0) ? depthVal : 0;
    }

    // Переопределение метода расчёта стоимости земляных работ
    double estimateCost() override {
        // Стоимость: 1500 руб за куб.м + надбавка за глубину
        double depthBonus = (depth > 2.0) ? (depth - 2.0) * 500 : 0;
        double totalCost = soilVolume * 1500 + depthBonus;
        return totalCost;
    }

    // Оценка уровня риска задержки
    string getRiskLevel() override {
        if (soilVolume > 500) return "ВЫСОКИЙ";
        if (soilVolume > 200) return "СРЕДНИЙ";
        return "НИЗКИЙ";
    }

    void printInfo() override {
        BuildingTask::printInfo();
        cout << "Объём грунта: " << soilVolume << " куб.м" << endl;
        cout << "Глубина:      " << depth << " м" << endl;
        cout << "Стоимость:    " << fixed << setprecision(2) 
             << estimateCost() << " руб." << endl;
        cout << "Риск задержки: " << getRiskLevel() << endl;
        cout << "==========================================" << endl;
    }

protected:
    string getTaskType() const override {
        return "Земляные работы";
    }
};

// ============================================================
// Производный класс: Отделочные работы
// ============================================================
class FinishingTask : public BuildingTask {
private:
    double surfaceArea;     // площадь поверхности в кв.м
    string finishType;      // тип отделки

public:
    FinishingTask(string name, string resp, int days, double percent,
                  double area, string type)
        : BuildingTask(name, resp, days, percent) {
        surfaceArea = (area > 0) ? area : 0;
        finishType = type;
    }

    // Расчёт стоимости отделочных работ
    double estimateCost() override {
        double pricePerSqm = 0;
        
        if (finishType == "штукатурка") pricePerSqm = 800;
        else if (finishType == "покраска") pricePerSqm = 500;
        else if (finishType == "обои") pricePerSqm = 600;
        else if (finishType == "плитка") pricePerSqm = 1500;
        else pricePerSqm = 400;
        
        return surfaceArea * pricePerSqm;
    }

    // Метод расчёта расхода материалов
    double calculateMaterials() {
        double materialConsumption = 0;
        
        if (finishType == "штукатурка") materialConsumption = surfaceArea * 15; // кг
        else if (finishType == "покраска") materialConsumption = surfaceArea * 0.3; // л
        else if (finishType == "обои") materialConsumption = surfaceArea / 5.0; // рулонов
        else if (finishType == "плитка") materialConsumption = surfaceArea * 1.05; // кв.м с запасом
        
        return materialConsumption;
    }

    string getRiskLevel() override {
        if (finishType == "плитка") return "СРЕДНИЙ (требуется квалификация)";
        if (surfaceArea > 300) return "СРЕДНИЙ";
        return "НИЗКИЙ";
    }

    void printInfo() override {
        BuildingTask::printInfo();
        cout << "Площадь:      " << surfaceArea << " кв.м" << endl;
        cout << "Тип отделки:  " << finishType << endl;
        cout << "Стоимость:    " << fixed << setprecision(2) 
             << estimateCost() << " руб." << endl;
        cout << "Расход материалов: " << calculateMaterials();
        if (finishType == "штукатурка") cout << " кг";
        else if (finishType == "покраска") cout << " л";
        else if (finishType == "обои") cout << " рул.";
        else if (finishType == "плитка") cout << " кв.м";
        cout << endl;
        cout << "Риск задержки: " << getRiskLevel() << endl;
        cout << "==========================================" << endl;
    }

protected:
    string getTaskType() const override {
        return "Отделочные работы";
    }
};

// ============================================================
// Функция main: демонстрация полиморфизма
// ============================================================
int main() {
    setlocale(LC_ALL, "Russian");
    
    const int N = 4;
    BuildingTask* tasks[N];
    
    // Создаём объекты разных типов
    tasks[0] = new ExcavationTask(
        "Котлован под фундамент", "Иванов И.И.", 14, 45.0,
        380.0, 3.5);
    
    tasks[1] = new FinishingTask(
        "Отделка квартиры 101", "Петрова А.А.", 21, 60.0,
        85.5, "штукатурка");
    
    tasks[2] = new ExcavationTask(
        "Траншея для коммуникаций", "Сидоров П.П.", 7, 90.0,
        150.0, 1.8);
    
    tasks[3] = new FinishingTask(
        "Плиточные работы в ванной", "Кузнецова М.И.", 10, 30.0,
        45.0, "плитка");
    
    // Демонстрация полиморфизма: вывод информации
    cout << "\n--- ИНФОРМАЦИЯ О ВСЕХ ЗАДАЧАХ ---\n" << endl;
    for (int i = 0; i < N; i++) {
        tasks[i]->printInfo();
        cout << endl;
    }
    
    // Демонстрация полиморфизма: обновление прогресса
    cout << "\n--- ОБНОВЛЕНИЕ ПРОГРЕССА ---\n" << endl;
    for (int i = 0; i < N; i++) {
        tasks[i]->updateProgress(tasks[i]->getCompletionPercent() + 10.0);
    }
    
    // Демонстрация полиморфизма: расчёт стоимости и риска
    cout << "\n--- ФИНАНСОВЫЙ АНАЛИЗ ---\n" << endl;
    double totalCost = 0;
    
    for (int i = 0; i < N; i++) {
        cout << "Задача: " << tasks[i]->getTaskName() << endl;
        double cost = tasks[i]->estimateCost();
        totalCost += cost;
        cout << "  Стоимость: " << fixed << setprecision(2) << cost << " руб." << endl;
        cout << "  Риск: " << tasks[i]->getRiskLevel() << endl;
        cout << endl;
    }
    
    cout << "ИТОГО СМЕТА: " << fixed << setprecision(2) 
         << totalCost << " руб." << endl;
    
    // Освобождение памяти
    cout << "\n--- ОСВОБОЖДЕНИЕ ПАМЯТИ ---\n" << endl;
    for (int i = 0; i < N; i++) {
        delete tasks[i];
    }
    
    return 0;
}
