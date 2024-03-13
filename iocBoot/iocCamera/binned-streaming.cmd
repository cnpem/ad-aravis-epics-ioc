# Load records for binned streaming and high resolution snapshots
#
# Parameters:
#
# $(PREFIX)
# Prefix for all PVs.

dbLoadRecords("$(TOP)/db/binned-streaming.db", "P=$(PREFIX), R=cam1:")
