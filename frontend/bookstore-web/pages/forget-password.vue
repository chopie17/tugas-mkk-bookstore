<template>
  <div class="min-h-[80vh] flex items-center justify-center px-4 py-12">
    <div 
      :class="isDark ? 'bg-slate-900 border-slate-800 shadow-2xl text-slate-100' : 'bg-white border-slate-200/80 shadow-xl text-slate-800'"
      class="max-w-md w-full p-8 rounded-3xl border transition-colors duration-300"
    >
      <div class="text-center mb-8">
        <div class="w-12 h-12 rounded-2xl bg-indigo-600 text-white flex items-center justify-center text-2xl mx-auto mb-3 shadow-md shadow-indigo-500/30">
          📧
        </div>
        <h2 :class="isDark ? 'text-white' : 'text-slate-900'" class="text-2xl font-bold">Lupa Password (Kode Email)</h2>
        <p :class="isDark ? 'text-slate-400' : 'text-slate-500'" class="text-xs mt-1">
          <span v-if="step === 1">Langkah 1: Masukkan email terdaftar untuk menerima kode verifikasi 6 digit</span>
          <span v-else-if="step === 2">Langkah 2: Masukkan 6 digit kode yang dikirim ke {{ verifiedEmail }}</span>
          <span v-else>Langkah 3: Buat password baru Anda</span>
        </p>
      </div>

      <div v-if="message" class="mb-4 p-3.5 rounded-xl bg-emerald-500/10 border border-emerald-500/30 text-emerald-400 text-xs font-medium">
        {{ message }}
      </div>

      <div v-if="errorMessage" class="mb-4 p-3.5 rounded-xl bg-rose-500/10 border border-rose-500/30 text-rose-400 text-xs font-medium">
        {{ errorMessage }}
      </div>

      <!-- Step 1: Input Email -->
      <form v-if="step === 1" @submit.prevent="sendCode" class="space-y-4">
        <div>
          <label :class="isDark ? 'text-slate-300' : 'text-slate-700'" class="block text-xs font-semibold mb-1">Email Terdaftar</label>
          <input 
            v-model="emailInput" 
            type="email" 
            required 
            :class="isDark ? 'bg-slate-950 border-slate-700 text-white placeholder-slate-500' : 'bg-white border-slate-300 text-slate-900'"
            class="w-full px-4 py-2.5 text-sm rounded-xl border focus:ring-2 focus:ring-indigo-500 outline-none" 
            placeholder="alamat@email.com" 
          />
        </div>

        <button type="submit" :disabled="loading" class="w-full py-3 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white font-semibold text-sm shadow-md shadow-indigo-500/20 transition-all disabled:opacity-50">
          <span v-if="loading">Mengirim Email...</span>
          <span v-else>📩 Kirim Kode 6 Digit Ke Email</span>
        </button>
      </form>

      <!-- Step 2: Input 6-Digit OTP Code -->
      <form v-else-if="step === 2" @submit.prevent="verifyCode" class="space-y-4">
        <div>
          <label :class="isDark ? 'text-slate-300' : 'text-slate-700'" class="block text-xs font-semibold mb-1">Kode Verifikasi 6 Digit (Cek Email Kamu)</label>
          <input 
            v-model="otpCode" 
            type="text" 
            maxlength="6" 
            required 
            :class="isDark ? 'bg-slate-950 border-indigo-500/50 text-indigo-300' : 'bg-indigo-50/50 border-indigo-300 text-indigo-900'"
            class="w-full px-4 py-3 text-center text-2xl font-mono font-extrabold tracking-widest rounded-xl border focus:ring-2 focus:ring-indigo-500 outline-none" 
            placeholder="123456" 
          />
        </div>

        <button type="submit" :disabled="loading || otpCode.length !== 6" class="w-full py-3 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white font-semibold text-sm shadow-md shadow-indigo-500/20 transition-all disabled:opacity-50">
          <span v-if="loading">Memverifikasi Kode...</span>
          <span v-else>Verifikasi Kode &rarr;</span>
        </button>

        <div class="text-center pt-2">
          <button type="button" @click="step = 1" class="text-xs text-indigo-500 hover:text-indigo-400 font-semibold">
            Kirim Ulang Kode Ke Email
          </button>
        </div>
      </form>

      <!-- Step 3: Input New Password -->
      <form v-else @submit.prevent="handleReset" class="space-y-4">
        <div>
          <label :class="isDark ? 'text-slate-300' : 'text-slate-700'" class="block text-xs font-semibold mb-1">Password Baru</label>
          <input 
            v-model="newPassword" 
            type="password" 
            required 
            :class="isDark ? 'bg-slate-950 border-slate-700 text-white placeholder-slate-500' : 'bg-white border-slate-300 text-slate-900'"
            class="w-full px-4 py-2.5 text-sm rounded-xl border focus:ring-2 focus:ring-indigo-500 outline-none" 
            placeholder="Minimal 6 karakter" 
          />
        </div>

        <div>
          <label :class="isDark ? 'text-slate-300' : 'text-slate-700'" class="block text-xs font-semibold mb-1">Konfirmasi Password Baru</label>
          <input 
            v-model="confirmPassword" 
            type="password" 
            required 
            :class="isDark ? 'bg-slate-950 border-slate-700 text-white placeholder-slate-500' : 'bg-white border-slate-300 text-slate-900'"
            class="w-full px-4 py-2.5 text-sm rounded-xl border focus:ring-2 focus:ring-indigo-500 outline-none" 
            placeholder="Ulangi password baru" 
          />
        </div>

        <button type="submit" :disabled="loading" class="w-full py-3 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-semibold text-sm shadow-md shadow-emerald-500/20 transition-all disabled:opacity-50">
          <span v-if="loading">Memperbarui Password...</span>
          <span v-else>Simpan Password Baru</span>
        </button>
      </form>

      <div :class="isDark ? 'text-slate-400' : 'text-slate-500'" class="mt-6 text-center text-xs">
        Kembali ke
        <NuxtLink to="/login" class="font-semibold text-indigo-500 hover:text-indigo-400">Halaman Login</NuxtLink>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  layout: 'auth'
})

const api = useApi()
const { isDark } = useTheme()

const step = ref(1)
const emailInput = ref('')
const verifiedEmail = ref('')
const otpCode = ref('')
const newPassword = ref('')
const confirmPassword = ref('')

const loading = ref(false)
const message = ref('')
const errorMessage = ref('')

// Step 1: Send 6-Digit Code to Email
const sendCode = async () => {
  loading.value = true
  message.value = ''
  errorMessage.value = ''

  try {
    const res = await api.post<{ message: string; email: string }>('/api/forgot-password/send-code', {
      email: emailInput.value
    })
    verifiedEmail.value = res.email
    message.value = res.message
    step.value = 2
  } catch (err: any) {
    errorMessage.value = err.data?.message || err.data?.errors?.email?.[0] || 'Gagal mengirim kode email.'
  } finally {
    loading.value = false
  }
}

// Step 2: Verify 6-Digit Code
const verifyCode = async () => {
  loading.value = true
  message.value = ''
  errorMessage.value = ''

  try {
    const res = await api.post<{ message: string }>('/api/forgot-password/verify-code', {
      email: verifiedEmail.value,
      code: otpCode.value
    })
    message.value = res.message
    step.value = 3
  } catch (err: any) {
    errorMessage.value = err.data?.message || 'Kode verifikasi tidak valid.'
  } finally {
    loading.value = false
  }
}

// Step 3: Reset Password
const handleReset = async () => {
  if (newPassword.value !== confirmPassword.value) {
    errorMessage.value = 'Konfirmasi password tidak cocok.'
    return
  }

  loading.value = true
  message.value = ''
  errorMessage.value = ''

  try {
    const res = await api.post<{ message: string }>('/api/forgot-password/reset', {
      email: verifiedEmail.value,
      code: otpCode.value,
      password: newPassword.value,
      password_confirmation: confirmPassword.value
    })
    alert(res.message)
    navigateTo('/login')
  } catch (err: any) {
    errorMessage.value = err.data?.message || 'Gagal memperbarui password.'
  } finally {
    loading.value = false
  }
}
</script>
