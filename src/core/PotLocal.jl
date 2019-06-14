"""
Class for holding the values of a local potential,
like the local part of a pseudopotential
"""
struct PotLocal
    values_real
    PotLocal(values_real::AbstractArray) = new(values_real)
end
