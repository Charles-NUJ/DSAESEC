using LinearAlgebra
using DataStructures
using DrWatson
using Graphs, GraphIO, Distributed
using Random, Distributions
using DrWatson
using Dates: Dates #println("$(Dates.now(Dates.UTC))")
using DataFrames, Statistics
quickactivate("age-optimal-multisource-flooding")
# import Pkg; Pkg.add("Graphs")



function run_experiment(graph_size, config)
	# @info "test"

	RAND_SEED_S = readlines("$(datadir())/Ly_exp_res/rand.txt")
	RAND_SEED_string = RAND_SEED_S[config["graph_id"]]
	RAND_SEED = tryparse(Int, RAND_SEED_string)
	# @info RAND_SEED
	Random.seed!(RAND_SEED)

	Method = config["method"]
	###################################################################################################
	T = 2000    # 10个时隙
	M = graph_size    # 2个用户
	arrive = config["a"]
	arr = zeros(Int, M, T)   # 整数类型 0
	K = 8 # 时钟频率
	CPU_S = [2.5, 5, 7.5, 10, 12.5, 15, 17.5, 20]
	gamma = 0.1
	alpha = 5
	belta = 3
	#一个节点的T个时间的到达
	arrive_init = []

	# 最新的队列
	H = zeros(M) #整数类型
	Q = zeros(M) #整数类型
	A = zeros(M) #整数类型
	P = zeros(M) #整数类型

	#历史的总队列
	H_T = []
	Q_T = []
	A_T = []
	P_T = []
	# x = zeros(Int,M) # 决策变量
	# s = zeros(Int,M) # 决策变量
	for i in 1:M
		a = rand(Poisson(arrive), T) # 长期平均期望就是2
		push!(arrive_init, a)
	end

	# A_max = rand(Poisson(2), T)
	A_max = 3# Normal(10,2)
	# value = Normal(10,2)

	a_max = trunc(M)

	value = rand(Normal(a_max, 2), M) # 长期平均期望就是2

	A_max = zeros(Int, M)
	for i in 1:M
		# A_max[i] = 
		A_max[i] = trunc(value[i])
	end
	# A_max = trunc(rand(Normal(3,0), 1)) # 长期平均期望就是2
	# @info A_max

	# A_max=3# Normal(10,2)
	####################################################################################################

	# @info value
	# @info A_max
	V = config["V"]

	# @info arrive_init

	# f = zeros(M,K) # 函数值
	# @info "当前的状态评估为 $(sizeof(f))"
	# @info f[4,3]  # 数组的索引方式-与class的索引方式不同


	for t in 1:T

		f = zeros(M, K) # 评估函数值

		# @info "t=$t ---------------------------  "
		for i in 1:M
			# @info "     若调度任务i=$i,其他都不调度"
			x = zeros(Int, M) # 决策变量
			x[i] = 1 # 设置决策任务
			for k in 1:K
				s = zeros(M) # 决策变量
				s[i] = CPU_S[k]
				# @info "     用频率$k 即 $(CPU_S[k])"

				# 计算 f[i][k] 
				for m in 1:M
					# theta_i = 1 - 2 * H[m] * A[m] + (A[m] + 1)^2
					# @info "             theta_i = $theta_i"
					# @info "i = $i, k=$k"
					# @info "$(f[i,k])"
					# temp = f[i, k]
					# X = (x[m] * s[m]) ./ gamma
					# if config["method"] == "QH"
						# f[i, k] = temp + V ./ M * alpha * (x[m] * s[m])^belta + x[m] * theta_i ./ 2 - Q[m] * X + X^2 / 2
					# elseif config["method"] == "H"
						# f[i, k] = temp + V ./ M * alpha * (x[m] * s[m])^belta + x[m] * theta_i ./ 2 #- Q[m] * X + X^2 / 2
					# elseif config["method"] == "Q"
						# f[i, k] = temp + V ./ M * alpha * (x[m] * s[m])^belta - Q[m] * X + X^2 / 2
					# end
					f[i, k] = temp + V ./ M * alpha * (x[m] * s[m])^belta
				end
			end
		end
		# @info "当前的状态评估为 $f"
		# val, loc = findmax(f)
		val, loc = findmax(f)
		# #当前决策为
		node_index = loc[1]
		cpu_index =  1
		# @info "当前决策为 node_index= $node_index , cpu_index=$cpu_index"

		#当前的能量消耗为


		# # 更新队列
		for i in 1:M
			if i == node_index
				A[i] = 1
			else
				A[i] = A[i] + 1
			end

			H[i] = max(H[i] - A_max[i], 0) + A[i]

			if i == node_index
				temp = max(Q[i] - (CPU_S[cpu_index]) ./ gamma, 0)
				#   @info  temp
				#   @info  arrive_init[i][t]
				Q[i] = temp + arrive_init[i][t]
			else
				Q[i] = max(Q[i], 0) + arrive_init[i][t]
			end

			#当前的能量消耗为
			# @info cpu_index
			if i == node_index
				P[i] = alpha * (CPU_S[cpu_index])^belta
			else
				P[i] = 0
			end
		end

		push!(Q_T, Q)
		push!(A_T, A)
		push!(H_T, H)
		push!(P_T, P)
	end

	# import Pkg; Pkg.add("Distributions")` to install the Distributions package.

	# @info Q_T 
	# @info A_T
	# @info A_T 
	# @info P_T 

	# @info mean(Q_T, dims = (1, 2))
	# # @info mean(A_T, dims = (1, 2))
	# @info mean(H_T, dims = (1, 2))

	average_Q = sum(sum(Q_T)) / T / M
	average_A = sum(sum(A_T)) / T / M
	average_P = sum(sum(P_T)) / T / M
	@info "$average_Q $average_A $average_P"
	result = @strdict average_Q average_A average_P
	wsave(datadir("Ly/$(Method)/$(graph_size)", savename(config, "jld2")), result)
end


# graph_ids = collect(1:num_graphs)


# params=dict_list(
#     Dict(
#     :"M" => [config["graph_id"]],
#     :"heuristic" => [false],
#     :"max_coding_degree"=> [graph_size],
#     :"cutoff" => [""],
#     :"rollback"=> [false],
#     ),
# )

# tmp_dir = "tmp_inf_nc/$(graph_type)"
# res = tmpsave(params, projectdir(tmp_dir))
# nc_config=""
# for r in res
#     nc_config = load(projectdir(tmp_dir, r), "params")
#     @info nc_config
# end

# run(config)

function run(graph_sizes, num_random_graphs, Vs, arrives, force_calculation, Methods)
	for Method in Methods

		for V in Vs
			for arrive in arrives
				for graph_size in graph_sizes
					num_graphs = num_random_graphs
					graph_ids = collect(1:num_graphs)
					graph_size_temp = [graph_size]
					V_temp = [V]
					arrive_temp = [arrive]
					Method_temp = [Method]

					params = dict_list(
						Dict(
							:"graph_size" => graph_size_temp,
							:"graph_id" => graph_ids,
							:"V" => V_temp,
							:"a" => arrive_temp,
							:"method" => Method_temp,
						),
					)

					tmp_dir = "Ly_tmp/"
					res = tmpsave(params, projectdir(tmp_dir))
					for r in res#[1:50] 
						config = load(projectdir(tmp_dir, r), "params")
						# if config["cutoff"]==0.2 && (config["graph_id"]>=10) #&& config["graph_id"]<=24
						if !isfile(datadir("Ly/$Method/$(graph_size)", savename(config, "jld2"))) || force_calculation
							println("Running Ly Greedy $config")
							# println("$(Dates.now())")
							run_experiment(graph_size, config) #@time 
						else
							println("Having done $config")
						end
						# end
					end
				end
			end
		end
	end
end
graph_sizes = [5, 10, 15, 20, 25]
Vs = [0.5, 5, 50,  500]
arrives = [2, 4, 6, 8, 10, 12]
num_random_graphs = 30


# graph_sizes = [5 ]
# Vs = [5]
# arrives = [2]
# num_random_graphs = 1


force_calculation = false
Methods = ["Greedy"]
run(graph_sizes, num_random_graphs, Vs, arrives, force_calculation, Methods)


# 要先生成随机种子存储起来 import Pkg; Pkg.add("StatsBase")
# using StatsBase

# R = 50
# M = 200
# nums = sample(1:M, R; replace=false)
# sort!(nums)
# @info nums

# open("$(datadir())/Ly_exp_res/rand.txt", "w") do f
#     [println(f, g) for g in nums]    
# end

# include("scripts/evaluations/Ly_main.jl") 
