# Problem Set I
#
# Student: Luan Mugarte

# Loading packages

using Pkg

import JLD2
import Random
import LinearAlgebra
import Statistics
import CSV
import DataFrames
import FreqTables
import Distributions

using JLD2
using Random
using LinearAlgebra
using Statistics
using CSV
using DataFrames
using FreqTables
using Distributions

#### Item 1 ####

function q1()
    
    # a)
    Random.seed!(1234)

    # i.
    A = rand(Uniform(-5,10),10,7)
    # ii.
    B = rand(Normal(-2,15),10,7)
    # iii.
    C = [A[1:5,1:5] B[1:5,6:7]]
    # iv,
    D = A
    D[D .> 0] .= 0
    D

    # b)
    length(A)

    # c)
    length(unique(A))

    # d)
    E = reshape(B,(70,1))

    ## I did not know an easier way to accomplish the vectorization,
    ## without having to use a loop.


    # e)
    F = cat(A,B, dims = 3)

    # f)
    F = permutedims(F,(3,1,2))

    # g)
    G = kron(B,C)
    #G2 = kron(C,F)

    ## Trying to use a Kronecker product between C and F turns a error due
    ## to different dimensions.

    # h)
    @save "matrixpractice.jld" A,B,C,D,E,F,G

    # i)
    @save "firstmatrix.jld" A,B,C,D

    # j)
    C = DataFrame(C)
    CSV.write("Cmatrix.csv",C)

    # k)
    D = DataFrame(D)
    CSV.write("Dmatrix.dat",D;delim="   ")

    return A,B,C,D

end;

A,B,C,D = q1()


# l)
q1()


#### Item 2 ####



