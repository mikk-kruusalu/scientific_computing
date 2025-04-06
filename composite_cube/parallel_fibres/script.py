import pandas as pd
import numpy as np

# Load the CSV
df = pd.read_csv("/gpfs/mariana/home/hvanav/scientific_computing/composite_cube/parallel_fibres/cube_100/data_y.csv")


# === Given stress (in Pa) ===
sigma_yy = 1000  # Pa, assumed uniform axial stress

# === Extract original dimensions ===
L_y = 0.5 # height in Y
L_x = 1  # width in X

# === Displacement in Y: axial strain ===
u_y_top = df.loc[df["Points:1"] == df["Points:1"].max(), "displacement:1"].mean()
u_y_bot = df.loc[df["Points:1"] == df["Points:1"].min(), "displacement:1"].mean()
eps_y = (u_y_top - u_y_bot) / L_y

# === Displacement in X: transverse strain ===
u_x_right = df.loc[df["Points:0"] == df["Points:0"].max(), "displacement:0"].mean()
u_x_left = df.loc[df["Points:0"] == df["Points:0"].min(), "displacement:0"].mean()
eps_x = (u_x_right - u_x_left) / L_x

# === Mechanical properties ===
E = sigma_yy / eps_y
nu = -eps_x / eps_y

# === Print results ===
print("====== Results ======")
print(f"Axial strain εy     = {eps_y:.3e}")
print(f"Transverse strain εx = {eps_x:.3e}")
print(f"Young's modulus E    = {E:.3e} Pa")
print(f"Poisson's ratio ν    = {abs(nu):.4f}")