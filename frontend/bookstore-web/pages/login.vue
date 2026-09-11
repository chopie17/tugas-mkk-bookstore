<template>
  <div class="min-h-[80vh] flex items-center justify-center px-4 py-12">
    <div 
      :class="isDark ? 'bg-slate-900 border-slate-800 shadow-2xl text-slate-100' : 'bg-white border-slate-200/80 shadow-xl text-slate-800'"
      class="max-w-md w-full p-8 rounded-3xl border transition-colors duration-300"
    >
      <div class="text-center mb-8">
        <div class="w-12 h-12 rounded-2xl bg-indigo-600 text-white flex items-center justify-center text-2xl mx-auto mb-3 shadow-md shadow-indigo-500/30">
          🔑
        </div>
        <h2 :class="isDark ? 'text-white' : 'text-slate-900'" class="text-2xl font-bold">Selamat Datang Kembali</h2>
        <p :class="isDark ? 'text-slate-400' : 'text-slate-500'" class="text-xs mt-1">Masuk ke akun BookStore Anda</p>
      </div>

      <div v-if="errorMessage" class="mb-4 p-3.5 rounded-xl bg-rose-500/10 border border-rose-500/30 text-rose-400 text-xs font-medium">
        {{ errorMessage }}
      </div>

      <form @submit.prevent="handleLogin" class="space-y-4">
        <div>
          <label :class="isDark ? 'text-slate-300' : 'text-slate-700'" class="block text-xs font-semibold mb-1">Username atau Email</label>
          <input 
            v-model="form.login" 
            type="text" 
            required 
            :class="isDark ? 'bg-slate-950 border-slate-700 text-white placeholder-slate-500 focus:border-indigo-500' : 'bg-white border-slate-300 text-slate-900 focus:border-indigo-500'"
            class="w-full px-4 py-2.5 text-sm rounded-xl border focus:ring-2 focus:ring-indigo-500 outline-none transition-colors" 
            placeholder="Masukkan username/email" 
          />
        </div>

        <div>
          <div class="flex justify-between items-center mb-1">
            <label :class="isDark ? 'text-slate-300' : 'text-slate-700'" class="text-xs font-semibold">Password</label>
            <NuxtLink to="/forget-password" class="text-xs font-medium text-indigo-500 hover:text-indigo-400">Lupa Password?</NuxtLink>
          </div>
          <input 
            v-model="form.password" 
            type="password" 
            required 
            :class="isDark ? 'bg-slate-950 border-slate-700 text-white placeholder-slate-500 focus:border-indigo-500' : 'bg-white border-slate-300 text-slate-900 focus:border-indigo-500'"
            class="w-full px-4 py-2.5 text-sm rounded-xl border focus:ring-2 focus:ring-indigo-500 outline-none transition-colors" 
            placeholder="••••••••" 
          />
        </div>

        <button type="submit" :disabled="loading" class="w-full py-3 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white font-semibold text-sm shadow-md shadow-indigo-500/20 transition-all disabled:opacity-50">
          <span v-if="loading">Memproses...</span>
          <span v-else>Masuk Sekarang</span>
        </button>
      </form>

      <div :class="isDark ? 'text-slate-400' : 'text-slate-500'" class="mt-6 text-center text-xs">
        Belum punya akun?
        <NuxtLink to="/register" class="font-semibold text-indigo-500 hover:text-indigo-400">Daftar Akun Baru</NuxtLink>
      </div>

      <!-- Quick Demo Account Hint -->
      <div :class="isDark ? 'border-slate-800 text-slate-400' : 'border-slate-100 text-slate-400'" class="mt-8 pt-6 border-t text-xs">
        <p :class="isDark ? 'text-slate-300' : 'text-slate-600'" class="font-semibold mb-1">Akun Demo Testing:</p>
        <p>• Admin: <code :class="isDark ? 'bg-slate-800 text-indigo-300' : 'bg-slate-100 text-slate-800'" class="px-1.5 py-0.5 rounded">admin</code> / <code :class="isDark ? 'bg-slate-800 text-indigo-300' : 'bg-slate-100 text-slate-800'" class="px-1.5 py-0.5 rounded">password</code></p>
        <p>• User: <code :class="isDark ? 'bg-slate-800 text-indigo-300' : 'bg-slate-100 text-slate-800'" class="px-1.5 py-0.5 rounded">userdemo</code> / <code :class="isDark ? 'bg-slate-800 text-indigo-300' : 'bg-slate-100 text-slate-800'" class="px-1.5 py-0.5 rounded">password</code></p>
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
  login: '',
  password: ''
})

const loading = ref(false)
const errorMessage = ref('')

const handleLogin = async () => {
  loading.value = true
  errorMessage.value = ''

  try {
    await authStore.login(form)
    if (authStore.isAdmin) {
      navigateTo('/admin/kategori')
    } else {
      navigateTo('/user/katalog')
    }
  } catch (err: any) {
    errorMessage.value = err.data?.message || err.data?.errors?.login?.[0] || 'Login gagal. Periksa kembali data Anda.'
  } finally {
    loading.value = false
  }
}
</script>
