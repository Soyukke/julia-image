using Images
using Base.Iterators
using Printf

function n_kakkei(N)
    return function(x, y)
        N_max = floor(N/2)
        result = 0
        for k in 1:N_max
            c1 = 2k*π/N
            result += abs(x*sin(c1) - abs(y)*cos(c1)) - sin(c1)
        end
        result += 1/2 * abs(y*sin(N*π/2)) - 1/2 * x*cot(N_max*π/N) + 1/2 * cot(N_max*π/N)
        return abs(result) 
    end
end

function main()
    N::Int64 = 128
    fimg = zeros(N, N)
    X = 1:N
    Y = 1:N
    # 正N角形 -> 正N+1角形へ
    for n in 3:10
        f1 = n_kakkei(n)
        f2 = n_kakkei(n+1)
        for t in 0:0.05:1
            f3 = (x, y) -> f1(x, y)*(1-t) + f2(x, y)*t
            map(x -> fimg[x...] = f3(((x.-N/2)./(N/3))...), product(X, Y))
            # @show max(fimg...)
            fimg = fimg ./ max(fimg...)
            img = Gray.(fimg)
            str = @sprintf "%02d_%.2f" n t
            save("img_henkei_$(str).jpg", img)
        end
    end
end


main()