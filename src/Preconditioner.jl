"""
Kinetic-energy based preconditioner.
Applies 1 / (|k + G|^2 + α) to the vectors, when called with ldiv!

The rationale is to dampen the high-kinetic energy parts of the
Hamiltonian and decreases their size, thus make the Hamiltonian
more well-conditioned
"""
struct PreconditionerKinetic
    basis::PlaneWaveBasis
    α::Float64
end

function PreconditionerKinetic(ham::Hamiltonian; α=0)
    PreconditionerKinetic(ham.basis, α)
end

function apply_inverse_fourier!(out_Xk, prec::PreconditionerKinetic, ik::Int, in_Xk)
    pw = prec.basis
    k = pw.kpoints[ik]

    qsq = [sum(abs2, pw.recip_lattice * (G + k)) for G in pw.wf_basis[ik]]
    diagonal = 1 ./ (qsq ./ 2 .+ 1e-6 .+ prec.α)
    out_Xk .= Diagonal(diagonal) * in_Xk
end
