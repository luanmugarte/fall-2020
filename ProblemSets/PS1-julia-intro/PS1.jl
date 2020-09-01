# Problem Set I
#
# Student: Luan Mugarte
# Group with: Gabriel Petrini

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

function q2(A,B,C)

    # a)
    AB = [x*y for (x,y) in zip(A, B)]

    AB2 = A .* B

    # b)
    Cprime = Vector{Float64}()
    for i in C
        if  -5 <= i  <= 5.0
            append!(Cprime, i)
        end
    end

    Cprime2 = C[-5 .<= C .<= 5]

    # c)
    N = 15169
    K = 6
    T = 5
    X = zeros(N,K,T)
    for t in 1:T
        X[:,1,t] .= ones(N) # stationary over time.
        X[:,2,t] .= rand(Bernoulli(.75*(6-t)/5), N)
        X[:,3,t] .= rand(Normal(15+t-1, 5*(t-1)), N)
        X[:,4,t] .= rand(Normal(π*(6-t)/3, 1/ℯ), N)
        X[:,5,t] .= rand(Binomial(20, 0.6), N)
        X[:,6,t] .= rand(Binomial(20,0.5),N) # Discrete normal stationary over time.
    end

    # d)

    β = zeros(K,T)
    β[1,:] .= [1 + t*(.25) for t in 1:T] # d1
    β[2,:] .= [log(t) for t in 1:T] # d2
    β[3,:] .= [-sqrt(t) for t in 1:T] # d3
    β[4,:] .= [(ℯ^(t)  - ℯ^(t+1)) for t in 1:T] # d4
    β[5,:] .= [t for t in 1:T] # d5
    β[6,:] .= [t/3 for t in 1:T] # d6

    # e)
    Y = zeros(N,T)
    for t in 1:T # How to use comprehensions in this case?
       Y[:,t] .= X[:,:,t]*β[:,t] + rand(Normal(0, .36), N)
    end
end

q2()

# 3
function q3()
    # a)
    df = CSV.read("./PS1-julia-intro/nlsw88.csv")# |> dropmissing
    save("./PS1-julia-intro/nlsw88.jld.jld", "df", df)
    # b)
    println((df.never_married |> sum)*100/nrow(df) |> round,"% sample has never been married")
    println((df.collgrad |> sum)*100/nrow(df) |> round,"% are college graduates")

    # c)
    freqtable(df.race) |> prop

    # d) 
    summarystats = describe(df)
    println(df.grade .|> ismissing |> sum, " grades observations are missing")

    # e)
    freqtable(df.occupation, df.industry) |> prop

    # f)
    gdf = groupby(df, ["occupation","industry"], sort=true) 
    combine(gdf, :wage => mean => :avg_ind_occ_wage) |> dropmissing 
    return nothing
end

q3()

#### Item 4 ####

# a)

function q4()
    load("./PS1-julia-intro/firstmatrix.jld")

    function matrixops(m1,m2)
        if size(m1) != size(m2)
            error("inputs must have the same size.")
        end
        #=
        Takes as inputs the matrices A and B from question (a) of problem 1 and has three outputs: 
            (i) the element-by-element product of the inputs, 
            (ii) the product A'B, and 
            (iii) the sum of all the elements of A + B.
        =#
        return m1 .* m2, m1' * m2, m1 + m2
    end

    a,b, c = matrixops(A, B);

    df = CSV.read("./PS1-julia-intro/nlsw88.csv") |> dropmissing
    convert(Array,df.ttl_exp); convert(Array,df.wage);
    matrixops(
        df.ttl_exp, 
        df.wage);
    return nothing
end

q4()

