using DrWatson
quickactivate("age-optimal-multisource-flooding")

using DataFrames, Statistics, PyPlot, Graphs, GraphIO, Colors


function get_value(M,method,V,arrive)
    df = collect_results(datadir("Lytemp/$(method)_$(V)_$(M)_$(arrive)"))
    return mean(df.average_A)
end
values = []
Q_values = []
P_values = []
H_values = []

# M = [5, 10, 15, 20, 25]
# Vs = [0.5, 5, 50,  500]
# Vs = [0.1, 1, 10,100,200]
# arrives = [2,3,4,5,6,7,8,9,10,11,12,14,16]


function plot_run(Ms)

for M in Ms

# Vs = [0.1, 0.2, 0.25, 0.5, 1, 5, 10, 25, 50, 100,200,300]
# Vs = [0.2, 5.0, 10, 25, 50, 100,200,300]
# Vs = [0.2, 0.25, 0.5, 1, 5, 10, 25, 50, 100,200,300]
# Vs = [0.2, 0.25, 0.5, 1, 5, 10, 25, 50, 100,200,300]
# Vs = [1, 5, 10, 25, 50.0, 100,200,300]
# Vs = [0.1, 0.2, 0.25, 0.5, 1]#, 5, 10, 25, 50, 100,200,300]
# Vs = [0.5, 1, 5, 10, 25, 50, 100,200,300]
Vs = [0.1, 0.2, 0.25, 0.5, 1, 5, 25, 50, 100, 200,300, 500.0]

# M=5
method="QH"



my_colors = ["#D43F3AFF", "#EEA236FF", "#5CB85CFF", "#46B8DAFF","#357EBDFF", "#9632B8FF", "#B8B8B8FF"]
fig, ax = PyPlot.subplots(figsize=(8, 5))

data_arrive0 = []
data_arrive1 = []
data_arrive2 = []
data_arrive3 = []
data_arrive4 = []
data_arrive5 = []
data_arrive6 = []
data_arrive7 = []
data_arrive8 = []
data_arrive9 = []
data_arrive10 = []
data_arrive11 = []
data_arrive12 = []
data_arrive14 = []
data_arrive16 = []

arrive=2
values=[]
for V in Vs
    append!(values,get_value(M,method,V,arrive))
end
data_arrive2 = values


arrive=4
values=[]
for V in Vs
    append!(values,get_value(M,method,V,arrive))

end
data_arrive4 = values

 

arrive=6
values=[]
for V in Vs
    append!(values,get_value(M,method,V,arrive))

end
data_arrive6 = values



arrive=8
values=[]
for V in Vs
    append!(values,get_value(M,method,V,arrive))
end
data_arrive8 = values



# xs = 1:1:length(Vs)
xs = Vs
# @info xs
# data = hcat(data_arrive2,data_arrive3, data_arrive4, data_arrive5,data_arrive6, data_arrive7,data_arrive8, data_arrive9,data_arrive10, data_arrive11, data_arrive12)
data = hcat(data_arrive2, data_arrive4, data_arrive6, data_arrive8)#, data_arrive10, data_arrive12,data_arrive14,data_arrive16)
Marker_Size = 2
Line_Width=2

my_colors = ["lightgreen", "limegreen", "green", "darkgreen"]
#         "lightskyblue", "deepskyblue", "cornflowerblue", "royalblue","blue", 
#         "grey", "black"]

plot(xs, data[:, 1], label = "\$M=20, \\lambda=2\$", linestyle = "-", color = "green", linewidth = Line_Width)
plot(xs, data[:, 2], label = "\$M=20, \\lambda=4\$", linestyle = "--", color = "green", linewidth = Line_Width)
plot(xs, data[:, 3], label = "\$M=20, \\lambda=6\$", linestyle = "-", color = my_colors[3] , linewidth = Line_Width)
plot(xs, data[:, 4], label = "\$M=20, \\lambda=8\$", linestyle = "-", color = my_colors[4] , linewidth = Line_Width)
# plot(xs, data[:, 5], label = "\$\\lambda=10\$", linestyle = "--", color = my_colors[5] , linewidth = Line_Width)
# plot(xs, data[:, 6], label = "\$\\lambda=12\$", linestyle = "--", color = my_colors[6] , linewidth = Line_Width)
# plot(xs, data[:, 7], label = "\$\\lambda=14\$", linestyle = "--", color = my_colors[7] , linewidth = Line_Width)
# plot(xs, data[:, 8], label = "\$\\lambda=16\$", linestyle = "--", color = "black" , linewidth = Line_Width)
# plot(xs, data[:, 9], label = "\$\\lambda=10\$", linestyle = "--", color = my_colors[9] , linewidth = Line_Width)
# plot(xs, data[:, 10], label = "\$\\lambda=11\$", linestyle = "--", color = my_colors[10] , linewidth = Line_Width)
# plot(xs, data[:, 11], label = "\$\\lambda=12\$", linestyle = "--", color = my_colors[11] , linewidth = Line_Width)

xlabel("V", fontsize = 12)
# xticks(collect(Vs), fontsize = 10, fontfamily = "Times New Roman")
# xticks(Vs,fontsize = 10)
# xticks(Vs,fontsize = 10)
xticks(fontsize = 10)

yticks(fontsize = 12)
ylabel("Average A", fontsize = 12)

# legend(bbox_to_anchor=(1.02, 1.0), loc="upper left")
# tight_layout()

legend(fontsize = 11)
size(500,100)
savefig(plotsdir("Ly_final_H_M_using20.png"), bbox_inches = "tight")
# savefig(plotsdir("Ly_final_P_M$M.eps"), bbox_inches = "tight")
# savefig(plotsdir("Ly_final_P_M$M.pdf"), bbox_inches = "tight")

end
end
Ms = [5, 10, 15, 20, 25]
Ms=[20]
plot_run(Ms)