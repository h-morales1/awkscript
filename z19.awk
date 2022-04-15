BEGIN {
    FS = ":"
    employees[0] = ""
    titles[0] = ""
    salaries[0] = 0
    project_managers[0] = 0
    projects[0] = ""
    who_s[0,0] = "" # project, emp_id = employee
    total_sal = 0
    total_employees = 0
}

/#/ {
    #exclude comments
    next
}

$1 ~ /E/ {
    employees[$2] = $3
    titles[$2] = $4
    salaries[$2] = $5
}

$1 ~ /P/ {
    #print "======", $3, " ======"
    #printf("Name%-5s", " ")
    #printf("Title%-5s", " ")
    #printf("Salary%-5s", " ")

    #print emp name, title, salary
    #print "\n"
    #get pms for each project
    project_managers[$3] = $4 # name of job is key, emp_id is saved
    #get all the projects
    projects[$2] = $3
}

$1 ~ /W/ {
    # track who is working on which project
    job = projects[$4]
    empID = $3
    who_s[job, empID] = employees[$3]
}

END {
    delete projects[0]
    delete employees[0]
    employee_ctr = 0
    sal_sum = 0
    sal_avg = 0
    #total_employees = 0
    #total_sal = 0
    tot_sal_avg = 0
    total_projects = 0
    for (emp in employees) {
        total_employees++
        total_sal += salaries[emp]
    }
    #print who_s[projects[1], 140]
    #print job header
    for(job_id in projects) {
        total_projects++
        print "=", projects[job_id], " ========="
        print "| ", "Name", "| ", "Title", "| ", "Salary", " |"
        print "================================="
        pm_id = project_managers[projects[job_id]]
        for(emp_ID in employees)
            if(who_s[projects[job_id], emp_ID] == "") {
                # dont print if not working on project
            } else {
                #print only employees working on specific project

                #check if the employee is a pm
                if (emp_ID == pm_id) {
                    # print with an asterisk
                    print "*", employees[emp_ID], " | ", titles[emp_ID], " | ", salaries[emp_ID]
                    employee_ctr++ # increase employee count
                    sal_sum += salaries[emp_ID] # add to salary sum
                } else {
                    # just print a normal employee and not a pm
                    print employees[emp_ID], " | ", titles[emp_ID], " | ", salaries[emp_ID]
                    employee_ctr++ # increase employee count
                    sal_sum += salaries[emp_ID] # add to salary sum
                }
            }
        print "|====================="
        sal_avg = sal_sum / employee_ctr
        #print "employed on project: ", employee_ctr, "   ", "Average salary: ", sal_avg
        printf("employed on project: %s  Average Salary: %.2f\n", employee_ctr, sal_avg)
        print " "
        #total_employees += employee_ctr
        #total_sal += sal_sum
        employee_ctr = 0
        sal_sum = 0
        sal_avg = 0
    }

    tot_sal_avg = total_sal / total_employees
    print " "
    print "Employees: ", total_employees, "Projects: ", total_projects
    printf("Total Salary: %.2f\n", total_sal)
    printf("Employee Average Salary: %.2f", tot_sal_avg)

}
