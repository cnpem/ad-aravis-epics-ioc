# Limit camera features
#
# Parameters:
#
# $(ACQUIRE_PERIOD_LOW_LIMIT)
# Minimum allowed value for AcquirePeriod PV, which effectively limits the
# maximum frame rate achievable with the camera

dbLoadRecords("$(TOP)/db/limits.db", "P=$(PREFIX), R=cam1:, ACQUIRE_PERIOD_DRVL=$(ACQUIRE_PERIOD_LOW_LIMIT)")
