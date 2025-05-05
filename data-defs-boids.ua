# Experimental!
I ~ "git: github.com/Marcos-cat/iris"
Dims ← ⊟ 1600 900 # width height

NumBoids      ← 500
Size          ← 6 # boid size
VelInit       ← 75
VelLimit      ← × 2 VelInit
Perception    ← 40
SeparationStr ← 0.7
AlignmentStr  ← 0.5
CohesionStr   ← 0.4
ChaseStr      ← 0.01

BlinkCycle ← 3    # seconds between blinks
BlinkDur   ← 0.25 # length of blink in seconds
NormalCol  ← ↯3 0.6
BlinkCol   ← Yellow
NudgeFlag  ← 0 # neighbors nudging timers defaults to false
NudgeAmt   ← ×BlinkCycle 0.01

┌─╴Boid
  ~ {
    Pos ← ⌊ /ℂ ×Dims [⚂⚂]
    Vel ← ⁅₂ ×VelInit ℂ °∠×τ ⚂
    Color ← NormalCol
    BlinkStart ← BlinkCycle
    BlinkEnd ← 0 # default value. This is updated to BlinkStart + BlinkDur
    Blinking ← 0 # defaults to false
    Timer ← 0    # keeps track of elapsed time since last blink
  }

  # Outputs perception matrix above boids
  # PercMat Boids ? Boids
  Perceive ← ≤Perception ⌵ ˙⊞- ⊸Pos

  # Updates velocities to steer away from boids within Perception radius
  # Boids Vars ? PercMat Boids Vars
  Separation ← (
    ⊙(˙⊞-⊸Pos) # calc position differences between all boids
    ×          # zero out position differences where distance is greater than perception
    ±/+        # calc normalized separation vectors per boid
    × ⊡₀⤙⊙⊙∘   # scale vectors
    ⍜Vel+ :    # add steering vectors to current velocities
  )

  # Updates velocities to steer towards avg velocity of boids within Perception radius
  # Boids Vars ? PercMat Boids Vars
  Alignment ← (
    ⊙⊸Vel    # put velocities below PercMat on stack
    ⊸×       # zero out velocity differences where distance is greater than perception
    ÷∩/+±⊸⌵  # calc average velocity of boids within Perception radius per boid
    -        # difference between current vel and avg vel per boid
    × ⊡₁⤙⊙⊙∘ # scale differences
    ⍜Vel˜- : # subtract differences from current velocities
  )

  # Updates velocities to steer towards the average position of boids within Perception radius
  # Boids Vars ? PercMat Boids Vars
  Cohesion ← (
    ⊙⊸Pos
    ⊸×       # fill each col with positions of boids within Perception radius
    ÷∩/+±⊸⌵  # calc average position of boids within Perception radius per boid
    ±-       # calc normalized vectors pointing at avg position per boid
    × ⊡₂⤙⊙⊙∘ # scale vectors
    ⍜Vel˜- : # subtract cohesion vectors from current velocities
  )

  # If Nudge flag is set, advance timers based on seeing flashes within perception radius
  # Boids Vars ? PercMat Boids Vars
  NudgeTimer ← (
    ◡⋅⋅⊡₃ # check Nudge Flag
    ⨬(◌
    | ×˙⊞≠°⊏              # remove self-checks from perception matrix
      /+ ×⊙⊸Blinking      # count blinking boids within perception radius
      ⍜Timer+ : ×NudgeAmt # nudge timers forward
    )
  )

  Flock       ← NudgeTimer ⟜(Cohesion|Alignment|Separation) Perceive
  Move        ← ⍜Pos+ ⟜(×I~Dt ⍜⌵(↥ VelInit ↧ VelLimit) Vel)
  Wrap        ← ⍜Pos⍜(⊟°ℂ|◿Dims)
  UpdateTimer ← ⍜(Timer|˜⍥×₀) ⊙≥ ⟜⊃(BlinkEnd|Timer) ⍜Timer(+I~Dt)
  Blink       ← ⍜Blinking◌ ⊙(×⊓⌟<≥) ⟜⊃(BlinkEnd|BlinkStart|Timer)
  UpdateCol   ← ⍜Color◌ : ⨬(NormalCol|BlinkCol) ⊸Blinking
  Update      ← UpdateCol Blink UpdateTimer Wrap Move Flock
  Render ← (
    I~Draw~Centered~Circle˜⊂0.6BlinkCol ×1.25Size ▽⊸⊃(Blinking|Pos)
    I~Draw~Centered~Square⊸⊃(Color|Size|Pos)
  )
└─╴

# create boids as struct of arrays
# boids ?
Reset ← (
  ⍥(⍚⊂ Boid)-₁NumBoids ⍚¤Boid
  ⍜Boid~BlinkEnd◌ ⟜(+BlinkDur Boid~BlinkStart) # populate BlinkEnd field
  ⍜Boid~Timer(×BlinkCycle∵⋅⚂)
)

[SeparationStr AlignmentStr CohesionStr NudgeFlag] # Place vars on stack
Reset                                              # Init boids
I~Open Dims "Boids"
°I~Screen~FPS 60

I~Loop!(
  I~Draw~Background Black
  𝄐⌞(⍜↙₃+:) ×0.1 ≡/- I~Key~Pressed ["sw" "ad" "qe"] # check input to updates strs
  ⍥⊙⍜⊣¬ ⊢I~Key~Pressed "f"                          # check input to update nudge flag
  ⍥⋅Reset /× I~Key~Down {I~Key~LeftControl @R}      # check input to reset boids
  Boid~Update
  Boid~Render
  I~Draw~Text White 50 ℂ 10 -50 ⊣Dims "Ctrl-r to Restart"
  I~Draw~Text White 25 ℂ 10 -150 ⊣Dims ⊂"Separation (W/S): " °⋕⁅₁⊡₀⤙⊙∘
  I~Draw~Text White 25 ℂ 10 -120 ⊣Dims ⊂"Alignment (A/D): " °⋕⁅₁⊡₁⤙⊙∘
  I~Draw~Text White 25 ℂ 10 -90 ⊣Dims ⊂"Cohesion (Q/E): " °⋕⁅₁⊡₂⤙⊙∘
  I~Draw~Text White 25 ℂ 10 -180 ⊣Dims ⊂"Nudge (F): " ⨬"False""True" ⊡₃⤙⊙∘
)
