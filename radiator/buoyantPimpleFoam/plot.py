import matplotlib.pyplot as plt
import pandas as pd


df = pd.read_csv("parallel-run.csv")
df.sort_values("cores", inplace=True)
print(df)

plt.plot(df["cores"], df["elapsed_time"]/60/60, "o-")
plt.xlabel("cores")
plt.ylabel("hours")
plt.savefig("speedup.png")
