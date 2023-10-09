# Post IOC initialization setup

create_monitor_set("ioc.req", 30, "P=$(PREFIX)")
set_savefile_name("ioc.req", "$(PREFIX).sav")
