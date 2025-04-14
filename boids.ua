# Experimental!
I ~ "git: github.com/Marcos-cat/iris"
Width    ← 1600
Height   ← 900
BoidSize ← 5

NumBoids      ← 500
Vel           ← 75
VelLimit      ← × 2 Vel
Perception    ← 40
SeparationStr ← 0.4
AlignmentStr  ← 0.3
CohesionStr   ← 0.25
ChaseStr      ← 0.01

# Outputs new velocities steering away from boids within Perception radius
# Vel ? PercMat Pos Vel
Separation ← (
  ⊙˙⊞-           # calc square distances and position differences between all boids
  ×              # zero out position differences where square distance is greater than perception
  ±/+            # calc normalized separation vectors per boid
  ×SeparationStr # scale vectors
  +              # add steering vectors to current velocities
)

# Outputs new velocities steering towards avg velocity of boids within Perception radius
# Vel ? PercMat Pos Vel
Alignment ← (
  𝄐⊸×           # zero out velocity differences where square distance is greater than perception
  ÷+ε∩/+±⊸⌵     # calc average velocity of boids within Perception radius per boid
  ⊸-            # difference between current vel and avg vel per boid
  ×AlignmentStr # scale differences
  -             # subtract differences from current velocities
)

# Outputs new velocities steering towards the average position of boids within Perception radius
# Vel ? PercMat Pos Vel
Cohesion ← (
  ⊸×           # fill each col with positions of boids within Perception radius
  ÷∩/+±⊸⌵      # calc average position of boids within Perception radius per boid
  ±-           # calc normalized vectors pointing at avg position per boid
  ×CohesionStr # scale vectors
  -            # subtract cohesion vectors from current velocities
)

# Outputs positions and new velocities steering towards target
# Pos Vel ? Target Pos Vel
Chase ← (
  ⤙-             # steering vectors from current positions to target pos
  ⊙(- ×ChaseStr) # subtract scaled steering vectors from current velocities
)

# Handles wrapping boids around screen edges
# Pos ? Pos
Wrap ← ⍜°ℂ(∩◿Width⟜Height)

# Outputs new positions by adding current velocities and handling screen wrap
# Pos ? Pos Vel
Update ← (
  ⊙(×I~Dt⍜⌵(↥ Vel ↧ VelLimit)) # cap velocities between Vel and VelLimit and mul by delta time
  +                            # update positions
  Wrap                         # handle screen wrap
)

I~Open ℂ Width Height "Boids"

# Generates random Pos and 2D Vel per boid
# Pos Vel ?
Reset ← (
  ×Vel ℂ °∠×τ ∵⋅⚂ ⊚ NumBoids
  ⌊ℂ ∩× Width⟜Height ∩∵⋅⚂ .⊚ NumBoids
)

Reset

I~Loop!(
  I~Draw~Background Black
  I~Draw~Text White 50 ℂ 10 -50 Height "Ctrl-r to Restart"
  ⍥⋅⋅Reset /× I~Key~Down {I~Key~LeftControl @R}
  I~Mouse!Down‼Left Chase
  ≤Perception ⌵ ⊸˙⊞-                  # Put perception matrix above positions and velocities on the stack
  ◌ ⟜₂(Cohesion|Alignment|Separation) # Apply rules and then pop perception matrix
  ⊸Update
  ⊸I~Draw~Centered~Square White BoidSize
)
