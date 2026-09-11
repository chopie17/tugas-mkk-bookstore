<template>
  <div class="min-h-[85vh] flex items-center justify-center px-4 py-12">
    <div 
      :class="isDark ? 'bg-slate-900 border-slate-800 shadow-2xl text-slate-100' : 'bg-white border-slate-200/80 shadow-xl text-slate-800'"
      class="max-w-lg w-full p-8 rounded-3xl border transition-colors duration-300"
    >
      <div class="text-center mb-8">
        <div class="w-12 h-12 rounded-2xl bg-indigo-600 text-white flex items-center justify-center text-2xl mx-auto mb-3 shadow-md shadow-indigo-500/30">
          📝
        </div>
        <h2 :class="isDark ? 'text-white' : 'text-slate-900'" class="text-2xl font-bold">Buat Akun Baru</h2>
        <p :class="isDark ? 'text-slate-400' : 'text-slate-500'" class="text-xs mt-1">Isi formulir pendaftaran untuk bergabung di BookStore</p>
      </div>

      <div v-if="errorMessage" class="mb-4 p-3.5 rounded-xl bg-rose-500/10 border border-rose-500/30 text-rose-400 text-xs font-medium">
        {{ errorMessage }}
      </div>

      <form @submit.prevent="handleRegister" class="space-y-4">
        <div>
          <label :class="isDark ? 'text-slate-300' : 'text-slate-700'" class="block text-xs font-semibold mb-1">Nama Lengkap</label>
          <input 
            v-model="form.name" 
            type="text" 
            required 
            :class="isDark ? 'bg-slate-950 border-slate-700 text-white placeholder-slate-500' : 'bg-white border-slate-300 text-slate-900'"
            class="w-full px-4 py-2.5 text-sm rounded-xl border focus:ring-2 focus:ring-indigo-500 outline-none" 
            placeholder="Contoh: Budi Santoso" 
          />
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label :class="isDark ? 'text-slate-300' : 'text-slate-700'" class="block text-xs font-semibold mb-1">Username (Unik)</label>
            <input 
              v-model="form.username" 
              type="text" 
              required 
              :class="isDark ? 'bg-slate-950 border-slate-700 text-white placeholder-slate-500' : 'bg-white border-slate-300 text-slate-900'"
              class="w-full px-4 py-2.5 text-sm rounded-xl border focus:ring-2 focus:ring-indigo-500 outline-none" 
              placeholder="budi123" 
            />
          </div>
          <div>
            <label :class="isDark ? 'text-slate-300' : 'text-slate-700'" class="block text-xs font-semibold mb-1">No. Telepon</label>
            <input 
              v-model="form.no_telp" 
              type="text" 
              :class="isDark ? 'bg-slate-950 border-slate-700 text-white placeholder-slate-500' : 'bg-white border-slate-300 text-slate-900'"
              class="w-full px-4 py-2.5 text-sm rounded-xl border focus:ring-2 focus:ring-indigo-500 outline-none" 
              placeholder="08123456789" 
            />
          </div>
        </div>

        <div>
          <label :class="isDark ? 'text-slate-300' : 'text-slate-700'" class="block text-xs font-semibold mb-1">Email (Unik)</label>
          <input 
            v-model="form.email" 
            type="email" 
            required 
            :class="isDark ? 'bg-slate-950 border-slate-700 text-white placeholder-slate-500' : 'bg-white border-slate-300 text-slate-900'"
            class="w-full px-4 py-2.5 text-sm rounded-xl border focus:ring-2 focus:ring-indigo-500 outline-none" 
            placeholder="budi@example.com" 
          />
        </div>

        <div>
          <label :class="isDark ? 'text-slate-300' : 'text-slate-700'" class="block text-xs font-semibold mb-1">Password</label>
          <input 
            v-model="form.password" 
            type="password" 
            required 
            :class="isDark ? 'bg-slate-950 border-slate-700 text-white placeholder-slate-500' : 'bg-white border-slate-300 text-slate-900'"
            class="w-full px-4 py-2.5 text-sm rounded-xl border focus:ring-2 focus:ring-indigo-500 outline-none" 
            placeholder="Minimal 6 karakter" 
          />
        </div>

        <div>
          <label :class="isDark ? 'text-slate-300' : 'text-slate-700'" class="block text-xs font-semibold mb-1">Foto Profil (Opsional)</label>
          <input 
            @change="handleFileChange" 
            type="file" 
            accept="image/*" 
            :class="isDark ? 'text-slate-400 file:bg-slate-800 file:text-indigo-300' : 'text-slate-500 file:bg-indigo-50 file:text-indigo-700'"
            class="w-full text-xs file:mr-4 file:py-2 file:px-4 file:rounded-xl file:border-0 file:text-xs file:font-semibold hover:file:opacity-80 transition-opacity" 
          />
        </div>

        <button type="submit" :disabled="loading" class="w-full py-3 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white font-semibold text-sm shadow-md shadow-indigo-500/20 transition-all disabled:opacity-50 mt-2">
          <span v-if="loading">Mendaftarkan...</span>
          <span v-else>Daftar Akun</span>
        </button>
      </form>

      <div :class="isDark ? 'text-slate-400' : 'text-slate-500'" class="mt-6 text-center text-xs">
        Sudah memiliki akun?
        <NuxtLink to="/login" class="font-semibold text-indigo-500 hover:text-indigo-400">Masuk di Sini</NuxtLink>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  layout: 'auth'
})

const authStore = useAuthStore()
const { isDark } = useTheme()

const form = reactive({
  name: '',
  username: '',
  email: '',
  no_telp: '',
  password: ''
})

const selectedFoto = ref<File | null>(null)
const loading = ref(false)
const errorMessage = ref('')

const handleFileChange = (e: Event) => {
  const target = e.target as HTMLInputElement
  if (target.files && target.files[0]) {
    selectedFoto.value = target.files[0]
  }
}

const handleRegister = async () => {
  loading.value = true
  errorMessage.value = ''

  try {
    const formData = new FormData()
    formData.append('name', form.name)
    formData.append('username', form.username)
    formData.append('email', form.email)
    formData.append('no_telp', form.no_telp)
    formData.append('password', form.password)
    if (selectedFoto.value) {
      formData.append('foto', selectedFoto.value)
    }

    await authStore.register(formData)
    navigateTo('/user/katalog')
  } catch (err: any) {
    const errors = err.data?.errors
    if (errors) {
      const firstKey = Object.keys(errors)[0]
      errorMessage.value = errors[firstKey][0]
    } else {
      errorMessage.value = err.data?.message || 'Registrasi gagal. Periksa kembali data Anda.'
    }
  } finally {
    loading.value = false
  }
}
</script>
