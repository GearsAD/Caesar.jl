# lets see if we can interpret the data

using Caesar, RoME, IncrementalInference
using CloudGraphs, Neo4j
# using Distributions
using JSON

using KernelDensityEstimate

using Base.Test

# TODO comment out for command line operation
include(joinpath(dirname(@__FILE__),"blandauthremote.jl"))
session = "RYPKEMA2"


configuration = CloudGraphs.CloudGraphConfiguration(dbaddress, 7474, dbusr, dbpwd, mongoaddress, 27017, false, "", "");
cloudGraph = connect(configuration);
conn = cloudGraph.neo4j.connection
registerGeneralVariableTypes!(cloudGraph)
Caesar.usecloudgraphsdatalayer!()


N=100
fg = Caesar.initfg(sessionname=session, cloudgraph=cloudGraph)


updatenewverts!(fg, N=N)



writeGraphPdf(fg)
@async run(`evince fg.pdf`)

setDBAllReady!(fg)


# totally reset to frontend built state in DB
resetentireremotesession(conn,session)



fg.fIDs



sortedvd = getnewvertdict(fg.cg.neo4j.connection, fg.sessionname)
#
# sortedvd[110240]
#
elem = sortedvd[110592][:frtend]
#
# elem["range"]
#
rn = recoverConstraintType(elem)

# pty = convert(PackedPose2DPoint2DBearingRangeDensity, rn)
# upt = convert(Pose2DPoint2DBearingRangeDensity, pty)

# @test norm(getPoints(rn.bearing)-getPoints(upt.bearing)) < 1e-10
# @test norm(getPoints(rn.range)-getPoints(upt.range)) < 1e-10

# plotKDE(upt.bearing)
plotKDE(rn.bearing)


vc = startdefaultvisualization(draworigin=true)

drawmarginalpoints!(vc, fg, :l200050)

getVal(fg, :l200050, api=dlapi)

visualizeallposes!(vc, fg, drawlandms=false)

# for lb in [:x1,:x2,:x3,:x4,:x5,:x6,:x7]
#   @show getKDEMax(getVertKDE(fg, lb))
# end
plotKDE(marginal(getKDE(getVert(fg,:l200050,api=dlapi)),[1;2]))











#
