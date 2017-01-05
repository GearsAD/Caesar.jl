# ROV visualization

using MeshIO, FileIO
using CoordinateTransformations
using Rotations
using ColorTypes: RGBA

abstract DrawModel <: Function

# Modified ROV model from GrabCAD
# http://grabcad.com/library/rov-7
type DrawROV <: DrawModel
  data
  visid::Int
  symbol::Symbol
  offset::AffineMap
end

function loadmodel(model::Symbol=:rov;
    color=RGBA(0., 1.0, 0.5, 0.3),
    offset = Translation(0.,0,0) ∘ LinearMap(Rotations.Quat(1.0,0,0,0))  )
  #
  if model==:rov
    @show file = joinpath(Pkg.dir("Caesar"), "data", "models", "rov2.obj")
    rov = load(file)
    rovdata = GeometryData(rov)
    rovdata.color = color
    offset = Translation(-0.5,0,0.25) ∘ LinearMap(Rotations.Quat(0,0,0,1.0))
    return DrawROV(rovdata, 99, :rov, offset)
  else
    error("Don't recognize requested $(string(model)) model.")
  end
end

#syntax support lost in 0.5, but see conversation at
# function (dmdl::DrawModel)(vc::VisualizationContainer)
# issue  https://github.com/JuliaLang/julia/issues/14919

function (dmdl::DrawROV)(vc::VisualizationContainer,
        am::AffineMap  )
  #
  # mam = am.m
  # if typeof(am.m)==Rotations.AngleAxis{Float64}
  #   mam = convert(Rotations.Quat, am.m)
  # end
  # res = SE3(am.v[1:3],Quaternion(mam.w,[mam.x;mam.y;mam.z]))*SE3(dmdl.offset.v[1:3],Quaternion(dmdl.offset.m.w,[dmdl.offset.m.x;dmdl.offset.m.y;dmdl.offset.m.z]))
  # q = convert(Quaternion, res.R)
  # DrakeVisualizer.draw(vc.models[dmdl.symbol], [Translation(res.t...) ∘ LinearMap(Rotations.Quat(q.s,q.v...))])

  DrakeVisualizer.draw(vc.models[dmdl.symbol], [am ∘ dmdl.offset])
  nothing
end
function (dmdl::DrawROV)(vc::VisualizationContainer,
        t::Translation,
        R::Rotation  )
  #
  dmdl(vc, t ∘ LinearMap(R))
  nothing
end
function (dmdl::DrawROV)(vc::VisualizationContainer)
  vc.models[dmdl.symbol] = Visualizer(dmdl.data, dmdl.visid)
  dmdl(vc, Translation(0.,0,0) ∘ LinearMap(Rotations.Quat(1.0,0,0,0)) )
end









#