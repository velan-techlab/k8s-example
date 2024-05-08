alb = {
    myapp_alb = {
       name = "myapp-alb"
       internal = false
       security_groups_ids = [
        "sgrp-myapp-alb"
       ]
       subnet_ids = [
        "myapp-public-subnet-01",
        "myapp-public-subnet-02"
       ]

    }
}
