using DrWatson
quickactivate("age-optimal-multisource-flooding")

using DataFrames, Statistics, PyPlot, Graphs, GraphIO, Colors


rc("font", family="SimSun", size=8)          # 默认字体：宋体（用于中文）
rc("mathtext", fontset="custom", rm="Times New Roman", it="Times New Roman:italic", bf="Times New Roman:bold")
rc("axes", unicode_minus=false)              # 避免负号乱码


colors = ["b", "r", "g", "orange", "purple", "c"]
linestyles = ["-", "--", "-.", ":", "-", "--"]
markers = ["o", "s", "^", "D", "*", "v"]

function get_value(M,method,V,arrive)
    df = collect_results(datadir("Lytemp/$(method)_$(V)_$(M)_$(arrive)"))
    return mean(df.average_Q)+mean(df.average_H)
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
Vs = [0.1, 0.2, 0.25, 0.5, 1, 5, 25, 50, 100, 200,300]#, 500.0]

# M=5
method="QH"


my_colors = ["#D43F3AFF", "#EEA236FF", "#5CB85CFF", "#46B8DAFF","#357EBDFF", "#9632B8FF", "#B8B8B8FF"]
# fig, ax = PyPlot.subplots(figsize=(6.5, 3.5))
figure(figsize=(6.5, 3.5))  # 论文双栏图宽度
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

# plot(xs, data[:, 1], label = "\$M=20, \\lambda=2\$", "-o", color = "green", linewidth = Line_Width)
# plot(xs, data[:, 2], label = "\$M=20, \\lambda=4\$", "-o" = "--", color = "green", linewidth = Line_Width)
# plot(xs, data[:, 3], label = "\$M=20, \\lambda=6\$",  "-o", color = my_colors[3] , linewidth = Line_Width)
# plot(xs, data[:, 4], label = "\$M=20, \\lambda=8\$",  "-o", color = my_colors[4] , linewidth = Line_Width)


plot(xs, data[:, 1], color="b",  linestyle="--",  marker="o", label="\$\\lambda=2\$",linewidth = Line_Width)
plot(xs, data[:, 2],color="r",  linestyle="--", marker="s", label="\$\\lambda=4\$",linewidth = Line_Width)
plot(xs, data[:, 3],color="g",  linestyle="--", marker="^", label="\$\\lambda=6\$",linewidth = Line_Width)
plot(xs, data[:, 4], color="orange", linestyle="--", marker="D", label="\$\\lambda=8\$",linewidth = Line_Width)





# plot(xs, data[:, 5], label = "\$\\lambda=10\$", linestyle = "--", color = my_colors[5] , linewidth = Line_Width)
# plot(xs, data[:, 6], label = "\$\\lambda=12\$", linestyle = "--", color = my_colors[6] , linewidth = Line_Width)
# plot(xs, data[:, 7], label = "\$\\lambda=14\$", linestyle = "--", color = my_colors[7] , linewidth = Line_Width)
# plot(xs, data[:, 8], label = "\$\\lambda=16\$", linestyle = "--", color = "black" , linewidth = Line_Width)
# plot(xs, data[:, 9], label = "\$\\lambda=10\$", linestyle = "--", color = my_colors[9] , linewidth = Line_Width)
# plot(xs, data[:, 10], label = "\$\\lambda=11\$", linestyle = "--", color = my_colors[10] , linewidth = Line_Width)
# plot(xs, data[:, 11], label = "\$\\lambda=12\$", linestyle = "--", color = my_colors[11] , linewidth = Line_Width)
xlabel("V参数", fontsize = 8)
# xticks(collect(Vs), fontsize = 10, fontfamily = "Times New Roman")
# xticks(Vs,fontsize = 10)
# xticks(Vs,fontsize = 10)
xticks(fontsize = 8)

# yticks(fontsize = 12)
ylabel("平均队列积压（个）", fontsize = 8)

# legend(bbox_to_anchor=(1.02, 1.0), loc="upper left")
# tight_layout()

PyPlot.grid(true, linestyle="--", color="gray", alpha=0.7)


legend(fontsize = 8)
size(500,100)
savefig(plotsdir("Ly_final_H_M_using20_final图7.png"), bbox_inches = "tight", dpi=1200)
# savefig(plotsdir("Ly_final_P_M$M.eps"), bbox_inches = "tight")
# savefig(plotsdir("Ly_final_P_M$M.pdf"), bbox_inches = "tight")

end
end
Ms = [5, 10, 15, 20, 25]
Ms=[20]
plot_run(Ms)