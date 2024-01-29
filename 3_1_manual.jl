using ITensors

X = [0 1 ; 1 0]
Z = [1 0 ; 0 -1]
I = [1 0; 0 1]
A = reshape([[1 0 ; 0 1]  [0 1 ; 0 0]],(2,2,2))
A0 = reshape([[1 0 ; 0 1]  [ 1/2 -1/2; 1/2 -1/2]],(2,2,2))

#initialize sites and index arrays
N = 3
inds_i = [Index(2, "i$i") for i in 1:N+1]
inds_p = [Index(2, "p$i") for i in 1:N]

#Combine into tensor network
#use A and x for eq 4.19 use A0 and Z for the problem
tens = [ITensor(A0, inds_i[i],inds_i[i+1],inds_p[i]) for i in 1:N]
push!(tens,ITensor(Z,inds_i[N+1],inds_i[1]))

#contract over a guess of the state
#the state is a W state so any combination of a single 1 and the rest zeros will result in 1
s_vec="001"
p_ind =Dict('0'=>[1 0], '1' => [0 1])
s_string=[p_ind[x] for x in s_vec]
sites = [ITensor(s_string[i], inds_p[i]) for i in 1:N]

cont = accumulate(*,vcat(tens,sites))[end]
print(cont.tensor)