<template>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
    <div class="mb-6 flex items-center justify-between">
      <div>
        <h1 :class="isDark ? 'text-white' : 'text-slate-900'" class="text-3xl font-extrabold">Live Chat Admin</h1>
        <p :class="isDark ? 'text-slate-400' : 'text-slate-500'" class="text-xs mt-1">Kelola dan balas obrolan pelanggan (HTTP Polling Active)</p>
      </div>

      <span :class="isDark ? 'bg-emerald-500/10 text-emerald-400 border-emerald-500/30' : 'bg-emerald-50 text-emerald-700 border-emerald-200'" class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold border">
        <span class="w-2 h-2 rounded-full bg-emerald-500 animate-ping"></span> Live Admin Connected
      </span>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 h-[600px]">
      <!-- User Conversations Sidebar -->
      <div :class="isDark ? 'bg-slate-900 border-slate-800' : 'bg-white border-slate-200/80'" class="rounded-3xl border shadow-sm overflow-hidden flex flex-col">
        <div :class="isDark ? 'bg-slate-950 border-slate-800 text-slate-300' : 'bg-slate-50 border-slate-100 text-slate-700'" class="p-4 border-b font-bold text-xs uppercase tracking-wider">
          Daftar Obrolan Pelanggan
        </div>

        <div :class="isDark ? 'divide-slate-800' : 'divide-slate-100'" class="flex-grow overflow-y-auto divide-y custom-scrollbar">
          <div v-if="loadingUsers" :class="isDark ? 'text-slate-500' : 'text-slate-400'" class="text-center py-10 text-xs">Memuat pengguna...</div>
          <div v-else-if="userList.length === 0" :class="isDark ? 'text-slate-500' : 'text-slate-400'" class="text-center py-10 text-xs">Belum ada obrolan masuk.</div>
          <div 
            v-for="u in userList" 
            :key="u.id" 
            @click="selectUser(u)" 
            :class="selectedUser?.id === u.id 
              ? (isDark ? 'bg-indigo-900/40 border-l-4 border-indigo-500' : 'bg-indigo-50/80 border-l-4 border-indigo-600')
              : (isDark ? 'hover:bg-slate-800' : 'hover:bg-slate-50')" 
            class="p-4 cursor-pointer transition-colors flex items-center gap-3"
          >
            <div class="w-10 h-10 rounded-full bg-indigo-600 text-white font-bold flex items-center justify-center shrink-0 text-sm shadow-sm">
              <img v-if="u.foto" :src="u.foto" :alt="u.name" class="w-full h-full object-cover rounded-full" />
              <span v-else>{{ u.name.charAt(0).toUpperCase() }}</span>
            </div>
            <div class="overflow-hidden flex-grow">
              <div class="flex justify-between items-baseline">
                <h4 :class="isDark ? 'text-white' : 'text-slate-900'" class="font-bold text-xs truncate">{{ u.name }}</h4>
                <span :class="isDark ? 'text-slate-500' : 'text-slate-400'" class="text-[9px]">{{ u.last_time }}</span>
              </div>
              <p :class="isDark ? 'text-slate-400' : 'text-slate-500'" class="text-[11px] truncate mt-0.5">{{ u.last_message || 'Obrolan baru' }}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Chat Box Panel -->
      <div :class="isDark ? 'bg-slate-900 border-slate-800' : 'bg-white border-slate-200/80'" class="md:col-span-2 rounded-3xl border shadow-lg overflow-hidden flex flex-col">
        <div v-if="!selectedUser" :class="isDark ? 'text-slate-500' : 'text-slate-400'" class="flex-grow flex flex-col items-center justify-center p-8 text-center">
          <div class="text-5xl mb-3">💬</div>
          <h4 :class="isDark ? 'text-slate-300' : 'text-slate-700'" class="font-bold text-sm">Pilih Obrolan Pelanggan</h4>
          <p :class="isDark ? 'text-slate-500' : 'text-slate-400'" class="text-xs mt-1">Pilih pengguna dari daftar di sebelah kiri untuk mulai membaca & membalas pesan.</p>
        </div>

        <template v-else>
          <!-- Active User Header -->
          <div :class="isDark ? 'bg-slate-950 border-slate-800' : 'bg-slate-50 border-slate-100'" class="p-4 border-b flex items-center justify-between">
            <div class="flex items-center gap-3">
              <div class="w-9 h-9 rounded-full bg-indigo-600 text-white font-bold flex items-center justify-center text-xs">
                {{ selectedUser.name.charAt(0).toUpperCase() }}
              </div>
              <div>
                <h4 :class="isDark ? 'text-white' : 'text-slate-900'" class="font-bold text-sm">{{ selectedUser.name }}</h4>
                <p :class="isDark ? 'text-slate-400' : 'text-slate-400'" class="text-[10px]">@{{ selectedUser.username }}</p>
              </div>
            </div>
          </div>

          <!-- Messages Container -->
          <div ref="chatContainer" :class="isDark ? 'bg-slate-950' : 'bg-slate-50/50'" class="flex-grow p-6 overflow-y-auto space-y-4 custom-scrollbar">
            <div v-for="chat in chats" :key="chat.id" :class="chat.sender === 'admin' ? 'justify-end' : 'justify-start'" class="flex items-end gap-2">
              <div v-if="chat.sender === 'user'" class="w-7 h-7 rounded-full bg-slate-700 text-white font-bold text-xs flex items-center justify-center shrink-0">
                U
              </div>

              <div 
                :class="chat.sender === 'admin' 
                  ? 'bg-indigo-600 text-white rounded-t-2xl rounded-l-2xl' 
                  : (isDark ? 'bg-slate-800 text-slate-100 border border-slate-700' : 'bg-white text-slate-800 border border-slate-200')" 
                class="p-3.5 max-w-sm text-xs space-y-1 rounded-t-2xl rounded-r-2xl shadow-sm"
              >
                <p class="font-semibold text-[10px] opacity-75">{{ chat.sender === 'admin' ? 'Saya (Admin)' : selectedUser.name }}</p>
                <p class="leading-relaxed whitespace-pre-wrap">{{ chat.pesan }}</p>
                <p class="text-[9px] text-right opacity-60">{{ chat.created_at }}</p>
              </div>

              <div v-if="chat.sender === 'admin'" class="w-7 h-7 rounded-full bg-indigo-600 text-white font-bold text-xs flex items-center justify-center shrink-0">
                A
              </div>
            </div>
          </div>

          <!-- Reply Input Form -->
          <form @submit.prevent="sendMessage" :class="isDark ? 'bg-slate-900 border-slate-800' : 'bg-white border-slate-100'" class="p-4 border-t flex items-center gap-3">
            <input 
              v-model="pesanInput" 
              type="text" 
              placeholder="Balas pesan ke pelanggan..." 
              required 
              :class="isDark ? 'bg-slate-950 border-slate-700 text-white placeholder-slate-500' : 'bg-slate-50 border-slate-300 text-slate-900'"
              class="flex-grow px-4 py-3 text-xs rounded-xl border focus:ring-2 focus:ring-indigo-500 outline-none" 
            />
            <button type="submit" :disabled="sending" class="px-5 py-3 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-semibold shadow-md shadow-indigo-500/20 transition-colors shrink-0 disabled:opacity-50">
              Balas 🚀
            </button>
          </form>
        </template>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  middleware: 'admin'
})

const api = useApi()
const { isDark } = useTheme()

const userList = ref<any[]>([])
const loadingUsers = ref(true)
const selectedUser = ref<any>(null)
const chats = ref<any[]>([])
const pesanInput = ref('')
const sending = ref(false)
const chatContainer = ref<HTMLElement | null>(null)
let pollTimer: any = null

const scrollToBottom = () => {
  nextTick(() => {
    if (chatContainer.value) {
      chatContainer.value.scrollTop = chatContainer.value.scrollHeight
    }
  })
}

const fetchUserList = async () => {
  try {
    const res = await api.get('/api/chats')
    userList.value = res.data || []
    if (!selectedUser.value && userList.value.length > 0) {
      selectedUser.value = userList.value[0]
      await fetchConversation()
    }
  } catch (e) {
    console.error(e)
  } finally {
    loadingUsers.value = false
  }
}

const fetchConversation = async () => {
  if (!selectedUser.value) return
  try {
    const res = await api.get(`/api/chats/user/${selectedUser.value.id}`)
    chats.value = res.data || []
    scrollToBottom()
  } catch (e) {
    console.error(e)
  }
}

const selectUser = async (u: any) => {
  selectedUser.value = u
  await fetchConversation()
}

const sendMessage = async () => {
  if (!selectedUser.value || !pesanInput.value.trim()) return

  sending.value = true
  const msg = pesanInput.value
  pesanInput.value = ''

  try {
    await api.post('/api/chats', {
      user_id: selectedUser.value.id,
      pesan: msg
    })
    await fetchConversation()
  } catch (err: any) {
    alert(err.data?.message || 'Gagal membalas pesan')
  } finally {
    sending.value = false
  }
}

onMounted(() => {
  fetchUserList()
  pollTimer = setInterval(() => {
    fetchUserList()
    if (selectedUser.value) fetchConversation()
  }, 3000)
})

onUnmounted(() => {
  if (pollTimer) clearInterval(pollTimer)
})
</script>
