# Herbert Morales
# z1959955
# CSCI-330-0001
BEGIN {
    FS = ":"
    employees[0] = "" # store all employee names using employee id as key
    titles[0] = "" # store the titles of each employee, using id as key
    salaries[0] = 0 # store salaries using employee id as key
    project_managers[0] = 0 # name of project id key, employee id is saved
    projects[0] = "" # project id is key, project name is saved
    who_s[0,0] = "" # project, emp_id = employee
    total_sal = 0
    total_employees = 0
}

/#/ {
    #exclude comments
    next
}

$1 ~ /E/ { # get all employee names by employee id
    employees[$2] = $3
    titles[$2] = $4 # titles by employee id
    salaries[$2] = $5 # salaries by employee id
}

$1 ~ /P/ {
    project_managers[$3] = $4 # name of job is key, emp_id is saved
    #get all the projects
    projects[$2] = $3
}

$1 ~ /W/ {
    # track who is working on which project
    job = projects[$4] # job name
    empID = $3
    who_s[job, empID] = employees[$3] # store employee name if they are present for a specific project
}

END {
    delete projects[0]
    delete employees[0]
    employee_ctr = 0
    sal_sum = 0
    sal_avg = 0
    tot_sal_avg = 0
    total_projects = 0
    for (emp in employees) {
        total_employees++ # get total employees
        total_sal += salaries[emp] # sum up all salaries
    }
    #print job header
    for(job_id in projects) {
        total_projects++ # increase total project count
        print "=", projects[job_id], " ========="
        printf("| %-18s | %-18s | %-18s |\n", "Name", "Title", "Salary")
        print "====================================================="
        pm_id = project_managers[projects[job_id]] # store the current project manager employee id
        for(emp_ID in employees)
            if(who_s[projects[job_id], emp_ID] == "") {
                # dont print if not working on project
            } else {
                #print only employees working on specific project

                #check if the employee is a pm
                if (emp_ID == pm_id) {
                    # print with an asterisk
                    printf("*%-19s | %-19s | %-19s|\n", employees[emp_ID], titles[emp_ID], salaries[emp_ID])
                    employee_ctr++ # increase employee count
                    sal_sum += salaries[emp_ID] # add to salary sum
                } else {
                    # just print a normal employee and not a pm
                    printf("%-20s | %-20s | %-20s|\n", employees[emp_ID], titles[emp_ID], salaries[emp_ID])
                    employee_ctr++ # increase employee count
                    sal_sum += salaries[emp_ID] # add to salary sum
                }
            }
        print "|==========================="
        sal_avg = sal_sum / employee_ctr
        printf("employed on project: %s  Average Salary: %.2f\n", employee_ctr, sal_avg)
        print ""
        employee_ctr = 0
        sal_sum = 0
        sal_avg = 0
    }

    tot_sal_avg = total_sal / total_employees
    print "Employees: ", total_employees, "Projects: ", total_projects
    printf("Total Salary: %.2f\n", total_sal)
    printf("Employee Average Salary: %.2f", tot_sal_avg)

}
