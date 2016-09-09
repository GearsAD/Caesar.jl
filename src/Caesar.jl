module Caesar

using
  IncrementalInference,
  RoME,
  KernelDensityEstimate,
  Gadfly,
  Colors,
  JLD,
  HDF5,
  JSON

# using GraphViz, Fontconfig, Cairo, Distributions, DataFrames

export
  # Victoria Park example -- batch
  loadVicPrkDataset,
  # addLandmarksFactoGraph!,
  # appendFactorGraph!,
  # doBatchRun,
  # insitu component
  GenericInSituSystem,
  makeGenericInSituSys,
  InSituSystem,
  makeInSituSys,
  triggerPose,
  poseTrigAndAdd!,
  processTreeTrackersUpdates!,
  advOdoByRules,
  progressExamplePlot,
  plotPoseDict,
  plotTrckStep,
  SLAMWrapper,

  # servers
  tcpStringSLAMServer,
  tcpStringBRTrackingServer,

  # save and load data
  saveSlam,
  loadSlam

  # shouldnt be here
  # wrapRad




include("VictoriaParkTypes.jl")
# using VictoriaParkTypes
include("VictoriaParkSystem.jl")
# include("VicPrkEstimator.jl")

include("SlamServer.jl")
include("BearingRangeTrackingServer.jl")

include("DataUtils.jl")

end
