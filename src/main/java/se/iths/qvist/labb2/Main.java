package se.iths.qvist.labb2;

import se.iths.qvist.labb2.model.AccessCard;
import se.iths.qvist.labb2.model.Department;
import se.iths.qvist.labb2.model.Employee;
import se.iths.qvist.labb2.model.Qualification;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class Main {
    static void main() {
        // Create Departments
        Department it = new Department(1, "IT", "Stockholm");
        Department hr = new Department(2, "HR", "Göteborg");
        Department sales = new Department(3, "Sales", "Malmö");
        Department finance = new Department(4, "Finance", "Stockholm");
        Department legal = new Department(5, "Legal", "Uppsala");

        List<Department> departments = List.of(it, hr, sales, finance, legal);

        // Create Employees
        Employee anna = new Employee(1, "Anna", "Svensson", "anna.svensson@company.test", LocalDate.of(2022, 3, 14), it);
        Employee erik = new Employee(2, "Erik", "Lindberg", "erik.lindberg@company.test", LocalDate.of(2023, 1, 9), it);
        Employee maja = new Employee(3, "Maja", "Karlsson", "maja.karlsson@company.test", LocalDate.of(2024, 6, 1), it);
        Employee johan = new Employee(4, "Johan", "Nilsson", "johan.nilsson@company.test", LocalDate.of(2021, 9, 20), hr);
        Employee sara = new Employee(5, "Sara", "Berg", "sara.berg@company.test", LocalDate.of(2025, 2, 3), hr);
        Employee oskar = new Employee(6, "Oskar", "Holm", "oskar.holm@company.test", LocalDate.of(2020, 11, 16), sales);
        Employee lina = new Employee(7, "Lina", "Ek", "lina.ek@company.test", LocalDate.of(2023, 8, 28), sales);
        Employee viktor = new Employee(8, "Viktor", "Dahl", "viktor.dahl@company.test", LocalDate.of(2024, 10, 7), sales);
        Employee emma = new Employee(9, "Emma", "Wallin", "emma.wallin@company.test", LocalDate.of(2022, 5, 30), finance);

        // Give some of the employees access cards
        anna.setAccessCard(new AccessCard(1001, LocalDate.of(2022, 3, 14), LocalDate.of(2027, 3, 14)));
        erik.setAccessCard(new AccessCard(1002, LocalDate.of(2023, 1, 9), LocalDate.of(2028, 1, 9)));
        johan.setAccessCard(new AccessCard(1003, LocalDate.of(2021, 9, 20), LocalDate.of(2026, 9, 20)));
        oskar.setAccessCard(new AccessCard(1004, LocalDate.of(2020, 11, 16), LocalDate.of(2025, 11, 16)));
        emma.setAccessCard(new AccessCard(1005, LocalDate.of(2022, 5, 30), LocalDate.of(2027, 5, 30)));

        // Create the qualifications
        Qualification java = new Qualification(1, "Java", "Programming in Java, including object-oriented design");
        Qualification sql = new Qualification(2, "SQL", "Designing and querying relational databases");
        Qualification projectLead = new Qualification(3, "Project lead", "Leading projects, planning and following up on teams");
        Qualification python = new Qualification(4, "Python", "Scripting and application development in Python");

        // Give some of the employees qualifications
        anna.addQualification(java);
        anna.addQualification(sql);
        anna.addQualification(projectLead);
        erik.addQualification(java);
        erik.addQualification(sql);
        maja.addQualification(java);
        johan.addQualification(sql);
        oskar.addQualification(projectLead);


        List<Employee> employees = List.of(anna, erik, maja, johan, sara, oskar, lina, viktor, emma);

        IO.println("------- Employees --------");

        for (Employee e : employees) {
            printEmployee(e);
        }


    }

    static void printEmployee(Employee e) {
        IO.println("Name: " + e.getFirstName() + " " + e.getLastName());
        IO.println("Department: " + e.getDepartment().getName()
                + " (" + e.getDepartment().getLocation() + ")");

        AccessCard card = e.getAccessCard();
        IO.println("Access Card: " + (card == null ? "None" : card.getCardNumber()));

        if (e.getQualifications().isEmpty()) {
            IO.println("Qualifications: None");
        } else {
            List<String> names = new ArrayList<>();
            for (Qualification q : e.getQualifications()) {
                names.add(q.getName());
            }
            IO.println("Qualifications: " + String.join(", ", names));
        }
        IO.println();
    }
}
