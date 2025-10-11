// Backend/src/store/memory.js
const state = {
  users: {
    // seed a demo user
    demoUser: { coins: 0 }
  }
};

export function getUser(userId) {
  if (!state.users[userId]) state.users[userId] = { coins: 0 };
  return state.users[userId];
}

export function addCoins(userId, n) {
  const u = getUser(userId);
  u.coins += n;
  return u.coins;
}

export function getCoins(userId) {
  return getUser(userId).coins;
}
