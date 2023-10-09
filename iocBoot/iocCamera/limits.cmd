# Limit camera features

dbLoadRecords("$(TOP)/db/limits.db", "P=$(PREFIX), R=cam1:, ACQUIRE_PERIOD_DRVL=$(ACQUIRE_PERIOD_LOW_LIMIT)")
