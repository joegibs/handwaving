using ITensors

function mera_site(inds_top,layer,site)
    A  = reshape([[1 0 ; 0 1]  [0 1 ; 0 0]],(2,2,2))
    inds_bot = [Index(2, "b$layer,l$layer,s$site,in$i") for i in 1:2]
    mera_block = ITensor(A, inds_bot[1],inds_top,inds_bot[2])
    return mera_block
end

function mera_first_layer()
    layer = 0
    site = 0
    A  = reshape([[1 0 ; 0 1]  [0 1 ; 0 0]],(2,2,2))
    inds_bot = [Index(2, "b$layer,l$layer,s$site,in$i") for i in 1:2]
    inds_top = Index(2, "t,l$layer,s$site")
    mera_block = ITensor(A, inds_bot[1],inds_top,inds_bot[2])
    return mera_block
end

function mera_network(depth)
    tens = [mera_first_layer()]
    temp=[]
    for i in 1:depth
        site=1
        for ten in tens
            if hastags(ten,"l$(i-1)")
                for ind in inds(ten)
                    if hastags(ind,"b$(i-1)")
                        push!(temp,mera_site(ind,i,site))
                        site+=1
                    end
                end
            end
        end
        append!(tens,temp)
    end
    return tens
end

#need a more efficient way to check
depth = 1
tens = mera_network(depth)
p_inds=[]
for ten in tens
    if any(hastags.(inds(ten),"b$depth"))
        append!(p_inds,inds(ten)[[hastags.(inds(ten),"b$depth")...]])
    end
end
str_sub(S,str,n1,n2) = @. SubString(S,1,n1-1) * str * SubString(S,n2+1,length(S))

s_vec=repeat("0", 2^(depth+1))
s_vec = str_sub(s_vec,"1",3,3)
s_vec = str_sub(s_vec,"1",4,4)

p_ind =Dict('0'=>[1 0], '1' => [0 1])
s_string=[p_ind[x] for x in s_vec]
sites = [ITensor(s_string[i], p_inds[i]) for i in 1:2^(depth+1)]
push!(sites,ITensor([0 1],inds(tens[1])[[hastags.(inds(tens[1]),"t")...]]))


cont = accumulate(*,vcat(tens,sites))[end]
print(cont.tensor)