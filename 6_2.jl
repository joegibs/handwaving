using ITensors

u = reshape([[1 0 ; 0 1]  [1 0 ; 0 -1]],(2,2,2))
v = reshape([[1 0 ; 0 0]  [0 0 ; 0 1]],(2,2,2))

inds_i = [Index(2, "i$i") for i in 1:4]
inds_p = [Index(2, "p$i") for i in 1:1]

#Combine into tensor network
#use A and x for eq 4.19 use A0 and Z for the problem
U = ITensor(u, inds_i[1],inds_i[2],inds_p[1])
V = ITensor(v, inds_i[3],inds_i[4],inds_p[1])

#contract to one tensor

C1 = combiner(inds_i[1],inds_i[3]; tags="c1")
C2 = combiner(inds_i[2],inds_i[4]; tags="c2")
(U*V*C1*C2).tensor