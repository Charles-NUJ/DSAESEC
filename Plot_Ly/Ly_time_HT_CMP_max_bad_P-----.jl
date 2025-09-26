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
    Q_t = mean(df.P_T_mean)
    # @info length(Q_t)
    return Q_t
end

AoI_values = []
Q_values = []
P_values = []
H_values = []

# M = [5, 10, 15, 20, 25]
# # Vs = [0.5, 5, 50,  500]
# Vs = [0.1, 1, 10,100,200]
# arrives = [2, 4, 6, 8, 10, 12]
 


function plot_run()

# for M in Ms

Vs = [0.1, 0.2, 0.25, 0.5, 1, 5, 10, 25, 50, 100,200,300]
Vs = [0.2, 5.0, 10, 25, 50, 100,200,300]
Vs = [0.2, 0.25, 0.5, 1, 5, 10, 25, 50, 100,200,300]
# M=5



my_colors = ["#D43F3AFF", "#EEA236FF", "#5CB85CFF", "#46B8DAFF","#357EBDFF", "#9632B8FF", "#B8B8B8FF","black"]
# fig, ax = PyPlot.subplots()
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

T = 3500
M=25
V = 300.0
arrive=8


method="Random"
data_arrive1 = get_value(M,method,V,arrive)
method="R"

method="Q"
data_arrive2 = get_value(M,method,V,arrive)

method="H"
data_arrive3 = get_value(M,method,V,arrive)

method="QH"
data_arrive4 = get_value(M,method,V,arrive)

# M=20
# method="Random"
# data_arrive1 = get_value(M,method,V,arrive)
# method="R"

# method="Q"
# data_arrive2 = get_value(M,method,V,arrive)

# method="H"
# data_arrive3 = get_value(M,method,V,arrive)

# method="QH"
# data_arrive4 = get_value(M,method,V,arrive)


# V = 100
# arrive=2
# data_arrive3 = get_value(M,method,V,arrive)

# arrive=3
# data_arrive4 = get_value(M,method,V,arrive)



# ########################################


# M=10
# V = 50
# arrive=2
# data_arrive5 = get_value(M,method,V,arrive)

# arrive=3
# data_arrive6 = get_value(M,method,V,arrive)

# V = 100
# arrive=2
# data_arrive7 = get_value(M,method,V,arrive)

# arrive=3
# data_arrive8 = get_value(M,method,V,arrive)

# data = hcat(data_arrive2) # 纵向组合
Marker_Size = 2
Line_Width=1.5

xs=1:1:3500

# plot(xs, data_arrive1[1:200], label ="\$ M=25, M-R\$",  linestyle = "-", color = "red", linewidth = Line_Width)
# plot(xs, data_arrive2[1:200], label ="\$ M=25, V=300, \\lambda=8, M-Q\$",  linestyle = "-", color = "blue", linewidth = Line_Width)
# plot(xs, data_arrive3[1:200], label ="\$ M=25, V=300, \\lambda=8, M-H\$",  linestyle = "-", color = "black", linewidth = Line_Width)
# plot(xs, data_arrive4[1:200], label ="\$ M=25, V=300, \\lambda=8, M-QH\$",  linestyle = "-", color = "green", linewidth = Line_Width)

plot(xs, data_arrive1, color="red",  linestyle="-", label ="M-R",linewidth = Line_Width)
plot(xs, data_arrive2,color="blue",  linestyle="-",  label ="M-Q", linewidth = Line_Width)
plot(xs, data_arrive3,color="black",  linestyle="-", label ="M-H",linewidth = Line_Width)
plot(xs, data_arrive4, color="green", linestyle="-", label ="M-QH",linewidth = Line_Width)

# plot(xs, data_arrive1[1:200], color="b",  linestyle="--",  marker="o", label ="M-R",linewidth = Line_Width)
# plot(xs, data_arrive1[1:200],color="r",  linestyle="--", marker="s", label ="M-Q", linewidth = Line_Width)
# plot(xs, data_arrive1[1:200],color="g",  linestyle="--", marker="^", label ="M-H",linewidth = Line_Width)
# plot(xs, data_arrive1[1:200], color="orange", linestyle="--", marker="D", data_arrive4[1:200], label ="M-QH",linewidth = Line_Width)


# plot(xs, data_arrive5, label ="\$ M=10,   \\lambda=2\$",  linestyle = "--", color = my_colors[3], linewidth = Line_Width)
# plot(xs, data_arrive6, label ="\$ M=10,   \\lambda=3\$",  linestyle = "--", color = my_colors[4], linewidth = Line_Width)
# plot(xs, data_arrive7, label ="\$ M=10, V=100, \\lambda=2\$",  linestyle = "--", color = my_colors[5], linewidth = Line_Width)
# plot(xs, data_arrive8, label ="\$ M=10, V=100, \\lambda=3\$",  linestyle = "--", color = my_colors[6], linewidth = Line_Width)

xlabel("时间 (个)")
ylabel("平均功耗 (毫瓦)")
legend(prop=Dict("family"=>"Times New Roman", "size"=>8, "weight"=>"bold"))

PyPlot.grid(true, linestyle="--", color="gray", alpha=0.7)

savefig(plotsdir("Ly_time_CMP_Q-QH_max_bad_P图6.png"), bbox_inches = "tight", dpi=1200)
# end
end
# Ms = [5]#, 10, 15, 20, 25]
plot_run()