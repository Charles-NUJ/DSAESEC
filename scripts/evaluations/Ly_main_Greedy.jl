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
	RAND_SEED_id = tryparse(Int, RAND_SEED_string)
	# @info RAND_SEED
	Random.seed!(RAND_SEED_id)

	Method = config["method"]
	###################################################################################################
	T = 3500    # 10个时隙
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


	H_T_mean = []
	Q_T_mean = []
	P_T_mean = []
	A_T_mean = []

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

	a_max =  # trunc(M)


	# value = rand(Normal(a_max, 2), M) # 长期平均期望就是2

	A_max = zeros(Int, M)
	for i in 1:M
		# A_max[i] = 
		A_max[i] =  15 # trunc(value[i])
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


	@inbounds for t in 1:T

		f = zeros(M, K) # 评估函数值

		# @info "t=$t ---------------------------  "
		@inbounds for i in 1:M
			# @info "     若调度任务i=$i,其他都不调度"
			x = zeros(Int, M) # 决策变量
			x[i] = 1 # 设置决策任务
			@inbounds for k in 1:K
				s = zeros(M) # 决策变量
				@inbounds s[i] = CPU_S[k]
				# @info "     用频率$k 即 $(CPU_S[k])"
				# 计算 f[i][k] 
				@inbounds for m in 1:M
					# @inbounds theta_i = 1 - 2 * H[m] * A[m] + (A[m] + 1)^2
					# @info "             theta_i = $theta_i"
					# @info "i = $i, k=$k"
					# @info "$(f[i,k])"
					@inbounds temp = f[i, k]
					# @inbounds X = (x[m] * s[m]) ./ gamma
					# if config["method"] == "QH"
						# @inbounds f[i, k] = temp + V ./ M * alpha * (x[m] * s[m])^belta + x[m] * theta_i ./ 2 - Q[m] * X + X^2 / 2
					# elseif config["method"] == "H"
						# f[i, k] = temp + V ./ M * alpha * (x[m] * s[m])^belta + x[m] * theta_i ./ 2
					# elseif config["method"] == "Q"
						# f[i, k] = temp + V ./ M * alpha * (x[m] * s[m])^belta - Q[m] * X + X^2 / 2
					# end
					f[i, k] = temp + V ./ M * alpha * (x[m] * s[m])^belta
				end
			end
		end


		# @info "当前的状态评估为 $f"
		# val, loc = findmax(f)
		val, loc = findmin(f)
		# #当前决策为
		node_index = loc[1]
		cpu_index = loc[2]
		# @info "当前决策为 node_index= $node_index , cpu_index=$cpu_index"

		#当前的能量消耗为


		# # 更新队列
		for i in 1:M
			if i == node_index
				@inbounds A[i] = 1
			else
				@inbounds A[i] = A[i] + 1
			end

			@inbounds H[i] = max(H[i] - A_max[i], 0) + A[i] # 先更新了 A[i] 即这里是 A(t+1)

			if i == node_index
				@inbounds temp = max(Q[i] - (CPU_S[cpu_index]) ./ gamma, 0)
				#   @info  temp
				#   @info  arrive_init[i][t]
				@inbounds Q[i] = temp + arrive_init[i][t]
			else
				@inbounds Q[i] = max(Q[i], 0) + arrive_init[i][t]
			end

			#当前的能量消耗为
			# @info cpu_index
			if i == node_index
				@inbounds P[i] = alpha * (CPU_S[cpu_index])^belta
			else
				@inbounds P[i] = 0
			end
		end

		# @info Q  mean(Q)

		push!(Q_T_mean, mean(Q)) #表示当前时间 系统队列的平均积压
		push!(A_T_mean, mean(A))
		push!(H_T_mean, mean(H))
		push!(P_T_mean, mean(P))

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
	average_H = sum(sum(A_T)) / T / M
	average_P = sum(sum(P_T)) / T / M
	
	# average_A_d1 = sum(Q_T)

	# @info "$average_A $average_Q $average_P $average_H"

	# @info lengthof(Q_T_mean)

	result = @strdict V arrive M RAND_SEED_id average_Q average_H average_A average_P Q_T_mean A_T_mean H_T_mean P_T_mean
	wsave(datadir("Lytemp/$(Method)_$(V)_$(M)_$(arrive)", savename(config, "jld2")), result)
end




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

					M = graph_size
					tmp_dir = "Ly_tmp/"
					res = tmpsave(params, projectdir(tmp_dir))
					for r in res#[1:50] 
						config = load(projectdir(tmp_dir, r), "params")
						# if config["cutoff"]==0.2 && (config["graph_id"]>=10) #&& config["graph_id"]<=24
						if !isfile(datadir("Lytemp/$(Method)_$(V)_$(M)_$(arrive)", savename(config, "jld2"))) || force_calculation
							println("Running Ly H 25 $config")
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
# Vs = [0.1, 0.2, 0.25, 0.5, 1, 5, 10, 25, 50, 100,200,300]
# Vs = [300.0]
graph_sizes = [5]
Vs = [0.5, 1, 5, 10, 25, 50, 100,200,300]
arrives = [2,3,4,5,6,7,8,9,10,11,12,14,16]
arrives = [2,3,4,5,6,7,8,9,10,11,12,14,16]
arrives = [4,6]
# arrives = [2,4,6,8,10,12]
num_random_graphs = 50


num_random_graphs = 1
arrives = [2,4,6,8]
graph_sizes=[5,10,15,20,25]
Vs = [0.5, 1, 5, 25, 50, 100, 200,300]

graph_sizes=[25]
arrives=[8]
Vs=[300.0]
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
# include("scripts/evaluations/Ly_main_QH.jl") 
