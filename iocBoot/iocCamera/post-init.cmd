# Post IOC initialization setup
#
# Optional parameters:
#
# $(USE_COMPRESSION)
# Use recommended compression settings (YES or NO). Defaults to NO.

create_monitor_set("ioc.req", 30, "P=$(PREFIX)")
set_savefile_name("ioc.req", "$(PREFIX).sav")

epicsEnvSet("USE_COMPRESSION", "$(USE_COMPRESSION=NO)")

epicsEnvSet("CODEC_COMPRESSOR_NO", "None")
epicsEnvSet("CODEC_COMPRESSOR_YES", "BSLZ4")
epicsEnvSet("CODEC_NUM_THREADS_NO", 1)
epicsEnvSet("CODEC_NUM_THREADS_YES", $(MAX_THREADS))

dbpf $(PREFIX)Codec1:EnableCallbacks Enable
dbpf $(PREFIX)Codec1:Mode Compress
dbpf $(PREFIX)Codec1:Compressor $(CODEC_COMPRESSOR_$(USE_COMPRESSION))
dbpf $(PREFIX)Codec1:NumThreads $(CODEC_NUM_THREADS_$(USE_COMPRESSION))
dbpf $(PREFIX)Codec1:SortMode Sorted
