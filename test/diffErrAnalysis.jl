
# measure errors between two graphs using MM definition
using Caesar, RoME, IncrementalInference, KernelDensityEstimate, Gadfly, Colors, Cairo
using HDF5, JLD

function rangeErrMaxPoint2(fgl1::FactorGraph, id1, fgl2::FactorGraph ,id2)
  mv1 = getKDEMax(getVertKDE(fgl1,id1))
  mv2 = getKDEMax(getVertKDE(fgl2,id2))
  return norm(mv1[1:2]-mv2[1:2])
end

function rangeCompAllPoses(fgl1::FactorGraph, fgl2::FactorGraph)
  ranges = Float64[]
  xx,ll = ls(fgl1)
  for x in xx
    push!(ranges, rangeErrMaxPoint2(fgl1,x,fgl2,x))
  end
  return ranges
end

function rangeCompAllPoses(
    valsbaseline::Dict{Int64,Array{Float64,1}},
    fglbaseline::FactorGraph,
    fgltest::FactorGraph)

  ranges = Float64[]
  xx,ll = ls(fgltest)
  for x in xx
    mv1 = valsbaseline[fglbaseline.IDs[x]]
    mv2 = getKDEMax(getVertKDE(fgltest,x))
    push!(ranges, norm(mv1[1:2]-mv2[1:2]))
  end
  return ranges
end

@load "results/fgT1400_Nightly7_28_perErr0.0.jld"
MMMAP0 = deepcopy(fg2)
UMMLE0d = deepcopy(isamdict)
UMMLE0fg = deepcopy(fgu)
rangesMM0_0 = rangeCompAllPoses(UMMLE0d, UMMLE0fg, MMMAP0)

@load "results/fgT1400_Friday7_29_perErr0.01.jld"
MMMAP1 = deepcopy(fg2)
UMMLE1d = deepcopy(isamdict)
UMMLE1fg = deepcopy(fgu)
rangesMM0_1 = rangeCompAllPoses(UMMLE1d, UMMLE1fg, MMMAP0)
rangesMM0_MM1 = rangeCompAllPoses(MMMAP0, MMMAP1)

@load "results/fgT1400_Friday7_29_perErr0.05.jld"
MMMAP5 = deepcopy(fg2)
UMMLE5d = deepcopy(isamdict)
UMMLE5fg = deepcopy(fgu)
rangesMM0_5 = rangeCompAllPoses(UMMLE5d, UMMLE5fg, MMMAP0)
rangesMM0_MM5 = rangeCompAllPoses(MMMAP0, MMMAP5)

@load "results/fgT1400_Friday7_29_perErr0.1.jld"
MMMAP10 = deepcopy(fg2)
UMMLE10d = deepcopy(isamdict)
UMMLE10fg = deepcopy(fgu)
rangesMM0_10 = rangeCompAllPoses(UMMLE10d, UMMLE10fg, MMMAP0)
rangesMM0_MM10 = rangeCompAllPoses(MMMAP0, MMMAP10)

@load "results/fgT1400_Friday7_29_perErr0.15.jld"
MMMAP15 = deepcopy(fg2)
UMMLE15d = deepcopy(isamdict)
UMMLE15fg = deepcopy(fgu)
rangesMM0_15 = rangeCompAllPoses(UMMLE15d, UMMLE15fg, MMMAP0)
rangesMM0_MM15 = rangeCompAllPoses(MMMAP0, MMMAP15)


@load "results/fgT1400_Friday7_29_perErr0.2.jld"
MMMAP20 = deepcopy(fg2)
UMMLE20d = deepcopy(isamdict)
UMMLE20fg = deepcopy(fgu)
rangesMM0_20 = rangeCompAllPoses(UMMLE20d, UMMLE20fg, MMMAP0)
rangesMM0_MM20 = rangeCompAllPoses(MMMAP0, MMMAP20)




ptsize = 1.8pt
# draw all
lyrs = []
push!(lyrs, Gadfly.layer(y=rangesMM0_0, Geom.line))

push!(lyrs, Gadfly.layer(y=rangesMM0_MM1, Geom.line, Theme(default_color=colorant"black")))
push!(lyrs, Gadfly.layer(y=rangesMM0_1, Geom.line, Theme(default_color=colorant"green")))

# push!(lyrs, Gadfly.layer(y=rangesMM0_5, Geom.line, Theme(default_color=colorant"yellow")))
# push!(lyrs, Gadfly.layer(y=rangesMM0_MM5, Geom.line, Theme(default_color=colorant"red")))

push!(lyrs, Gadfly.layer(y=rangesMM0_10, Geom.point, Theme(default_color=colorant"magenta", default_point_size=ptsize)))
push!(lyrs, Gadfly.layer(y=rangesMM0_MM10, Geom.point, Theme(default_color=colorant"black", default_point_size=ptsize)))

# push!(lyrs, Gadfly.layer(y=rangesMM0_15, Geom.line, Theme(default_color=colorant"cyan")))
# push!(lyrs, Gadfly.layer(y=rangesMM0_MM15, Geom.line, Theme(default_color=colorant"red")))

push!(lyrs, Gadfly.layer(y=rangesMM0_20, Geom.point, Theme(default_color=colorant"blue", default_point_size=ptsize)))
push!(lyrs, Gadfly.layer(y=rangesMM0_MM20, Geom.point, Theme(default_color=colorant"black", default_point_size=ptsize)))

push!(lyrs, Coord.Cartesian(xmin=0,xmax=length(rangesMM0_0),
                            ymin=0,ymax=350))

push!(lyrs,
  Guide.xlabel("Individual poses")
)
push!(lyrs,
  Guide.ylabel("| X - X' |,  [meters]")
)
push!(lyrs,
Guide.manual_color_key("", ["MM-MAP", "MLE ~0%", "MLE 1%", "MLE 10%", "MLE 20%"], ["black", "deepskyblue", "green", "magenta", "blue"])
)
push!(lyrs,
Theme(key_position=:top)
)

lpl = Gadfly.plot(lyrs...)
draw(PDF("poseErrs.pdf",15cm,8cm),lpl)
lpl

pl = drawCompPosesLandm(MMMAP10,UMMLE10d, UMMLE10fg, lbls=false,drawunilm=false)
pl.coord = Coord.Cartesian(xmin=-120,xmax=250,ymin=-100,ymax=250)
draw(PNG("VicPrk10.png",15cm,12cm),pl)


vpl = vstack(pl,lpl);
draw(PDF("test.pdf",15cm,24cm),vpl)

#sd