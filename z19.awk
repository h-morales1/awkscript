BEGIN {
    FS = ":"
    employees[0] = ""
    titles[0] = ""
    salaries[0] = 0
    project_managers[0] = 0
    projects[0] = ""
    who_s[0,0] = "" # project, emp_id = employee
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
    #print who_s[projects[1], 140]
    #print job header
    for(job_id in projects) {
        print "=", projects[job_id], " ========="
        print "| ", "Name", "| ", "Title", "| ", "Salary", " |"
        print "================================="
        pm_id = project_managers[projects[job_id]]
        for(emp_ID in employees)
            if(who_s[projects[job_id], emp_ID] == "") {
                #print who_s[projects[job_id], empID]
            } else {
                print who_s[projects[job_id], empID]
            }
        print "\n"
    }

}
