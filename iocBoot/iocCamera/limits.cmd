# Limit camera features
#
# Optional parameters:
#
# $(ACQUIRE_PERIOD_LOW_LIMIT)
# Minimum allowed value for AcquirePeriod PV, which effectively limits the
# maximum frame rate achievable with the camera
# Defaults to 0 (which is equivalent to having no limit).

dbLoadRecords("$(TOP)/db/limits.db", "P=$(PREFIX), R=cam1:, ACQUIRE_PERIOD_DRVL=$(ACQUIRE_PERIOD_LOW_LIMIT=0)")
