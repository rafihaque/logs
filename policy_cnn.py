'''Solves Pong with Policy Gradients in Tensorflow.'''
# written October 2016 by Sam Greydanus
# inspired by karpathy's gist.github.com/karpathy/a4166c7fe253700972fcbc77e4ea32c5
import numpy as np
import gym
import tensorflow as tf
from timeit import default_timer
# hyperparameters
n_obs = 80 * 80  # dimensionality of observations
h = 200  # number of hidden layer neurons
n_actions = 3  # number of available actions
learning_rate = 1e-3
gamma = .99  # discount factor for rward
decay = 0.99  # decay rate for RMSProp gradients
save_path = '/home/rhaque2/cs557/final_project/cnn_3/pong_cnn_3.ckpt'
log_path = '/home/rhaque2/cs557/final_project/cnn_3/log_cnn_3.txt'
monitor = True
save_path = '/Users/rafihaque/logs/'
model_path = save_path + 'pong_cnn_3.ckpt-1750'

# gamespace
env = gym.make("Pong-v0")  # environment info
observation = env.reset()
prev_x = None
xs, rs, ys = [], [], []
running_reward = None
reward_sum = 0
episode_number = 0
if monitor:
    env.monitor.start(save_path, force=True, seed=0)
observation = env.reset()
prev_x = None
xs, rs, ys = [], [], []
running_reward = None
reward_sum = 0
episode_number = 0

## initialize mode
tf_model = {}
with tf.variable_scope('layer_one', reuse=False):
    tf_model['W1']= tf.get_variable("W1", shape=[8,8,1,4], initializer=tf.contrib.layers.xavier_initializer())
with tf.variable_scope('layer_three', reuse=False):
    tf_model['W2'] = tf.get_variable("W2", shape=[40 * 40 * 4, 64], initializer=tf.contrib.layers.xavier_initializer())
with tf.variable_scope('layer_four', reuse=False):
    tf_model['W3'] = tf.get_variable("W3", shape=[64, n_actions], initializer=tf.contrib.layers.xavier_initializer())





def tf_policy_forward(x):  # x ~ [1,D]
    image_size = 80
    h = tf.reshape(x,[-1,image_size,image_size,1])
    h = tf.nn.relu(conv2d(h, tf_model['W1']))

    h = max_pool_2x2(h)
    h = tf.reshape(h,[-1,40*40*4])
    h = tf.nn.relu(tf.matmul(h,tf_model['W2']))
    h = tf.matmul(h,tf_model['W3'])
    return tf.nn.softmax(h)

def conv2d(x, W):
  return tf.nn.conv2d(x, W, strides=[1, 1, 1, 1], padding='SAME')

def max_pool_2x2(x):
  return tf.nn.max_pool(x, ksize=[1, 2, 2, 1],strides=[1, 2, 2, 1], padding='SAME')






# downsampling
def prepro(I):
    """ prepro 210x160x3 uint8 frame into 6400 (80x80) 1D float vector """
    I = I[35:195]  # crop
    I = I[::2, ::2, 0]  # downsample by factor of 2
    I[I == 144] = 0  # erase background (background type 1)
    I[I == 109] = 0  # erase background (background type 2)
    I[I != 0] = 1  # everything else (paddles, ball) just set to 1
    return I.astype(np.float).ravel()


# tf placeholders
tf_x = tf.placeholder(dtype=tf.float32, shape=[None, n_obs], name="tf_x")



# tf optimizer op
tf_aprob = tf_policy_forward(tf_x)


# tf graph initialization
sess = tf.InteractiveSession()
tf.initialize_all_variables().run()

# try load saved model
saver = tf.train.Saver(tf.all_variables())
saver.restore(sess, model_path)
print "loaded model: {}".format(model_path)

# play loop
done = False
while not done:
    env.render()

    # preprocess the observation, set input to network to be difference image
    cur_x = prepro(observation)
    x = cur_x - prev_x if prev_x is not None else np.zeros(n_obs)
    prev_x = cur_x

    # stochastically sample a policy from the network
    feed = {tf_x: np.reshape(x, (1, -1))}
    aprob = sess.run(tf_aprob, feed);
    aprob = aprob[0, :]
    action = np.random.choice(n_actions, p=aprob)
    label = np.zeros_like(aprob);
    label[action] = 1

    # step the environment and get new measurements
    observation, reward, done, info = env.step(action + 1)
    reward_sum += reward

print 'Score: {}'.format(reward_sum)
