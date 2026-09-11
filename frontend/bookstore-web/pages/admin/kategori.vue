<template>
  <div class="space-y-6">
    <!-- Header -->
    <div
      :class="isDark ? 'bg-slate-900 border-slate-800 text-slate-100' : 'bg-white border-slate-200 text-slate-900'"
      class="p-5 rounded-2xl border flex flex-col sm:flex-row sm:items-center justify-between gap-4 shadow-sm"
    >
      <div>
        <h1 :class="isDark ? 'text-white' : 'text-slate-900'" class="text-2xl font-black font-serif tracking-tight">
          Manajemen Kategori
        </h1>
        <p :class="isDark ? 'text-slate-400' : 'text-slate-500'" class="text-xs mt-1">
          Kelola kategori buku. Nama kategori harus unik.
        </p>
      </div>
      <button
        @click="openCreateModal"
        class="px-5 py-2.5 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-black shadow-md transition-all active:scale-95 whitespace-nowrap"
      >
        + Tambah Kategori
      </button>
    </div>

    <!-- Table -->
    <div
      :class="isDark ? 'bg-slate-900 border-slate-800' : 'bg-white border-slate-200'"
      class="rounded-2xl border overflow-hidden shadow-sm"
    >
      <div v-if="loading" :class="isDark ? 'text-slate-500' : 'text-slate-400'" class="text-center py-14 text-sm font-semibold">
        Memuat kategori...
      </div>
      <div v-else-if="categories.length === 0" :class="isDark ? 'text-slate-500' : 'text-slate-400'" class="text-center py-14 text-sm">
        <div class="text-4xl mb-2">🏷️</div>
        Belum ada kategori.
      </div>
      <table v-else class="w-full text-left text-xs">
        <thead>
          <tr :class="isDark ? 'bg-slate-800 text-slate-300 border-slate-700' : 'bg-slate-50 text-slate-600 border-slate-200'" class="border-b font-black uppercase text-[10px] tracking-wider">
            <th class="px-4 py-3">No</th>
            <th class="px-4 py-3">Nama Kategori</th>
            <th class="px-4 py-3">Jumlah Buku</th>
            <th class="px-4 py-3">Tanggal Dibuat</th>
            <th class="px-4 py-3 text-right">Aksi</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="(cat, idx) in categories"
            :key="cat.id"
            :class="isDark ? 'border-slate-800 hover:bg-slate-800/50' : 'border-slate-100 hover:bg-slate-50'"
            class="border-b last:border-b-0 transition-colors"
          >
            <td :class="isDark ? 'text-slate-500' : 'text-slate-400'" class="px-4 py-3 font-semibold">{{ idx + 1 }}</td>
            <td :class="isDark ? 'text-white' : 'text-slate-900'" class="px-4 py-3 font-bold">{{ cat.nama_kategori }}</td>
            <td class="px-4 py-3">
              <span :class="isDark ? 'bg-indigo-900/60 text-indigo-300' : 'bg-indigo-50 text-indigo-700'" class="px-2.5 py-1 rounded-full font-semibold text-[10px]">
                {{ cat.books_count || 0 }} Buku
              </span>
            </td>
            <td :class="isDark ? 'text-slate-400' : 'text-slate-500'" class="px-4 py-3">{{ cat.created_at }}</td>
            <td class="px-4 py-3 text-right">
              <div class="flex items-center justify-end gap-2">
                <button
                  @click="openEditModal(cat)"
                  :class="isDark ? 'bg-amber-900/40 text-amber-400 hover:bg-amber-900/70' : 'bg-amber-50 text-amber-700 hover:bg-amber-100'"
                  class="px-3 py-1.5 rounded-lg font-semibold transition-colors"
                >
                  Edit
                </button>
                <button
                  @click="deleteCategory(cat)"
                  :class="isDark ? 'bg-rose-900/40 text-rose-400 hover:bg-rose-900/70' : 'bg-rose-50 text-rose-700 hover:bg-rose-100'"
                  class="px-3 py-1.5 rounded-lg font-semibold transition-colors"
                >
                  Hapus
                </button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Modal Form -->
    <div v-if="showModal" class="fixed inset-0 bg-slate-950/70 backdrop-blur-sm z-50 flex items-center justify-center p-4">
      <div
        :class="isDark ? 'bg-slate-900 border-slate-700 text-slate-100' : 'bg-white border-slate-200 text-slate-900'"
        class="rounded-2xl p-6 max-w-md w-full shadow-2xl border space-y-4"
      >
        <div class="flex items-center justify-between">
          <h3 :class="isDark ? 'text-white' : 'text-slate-900'" class="font-black text-lg">
            {{ isEdit ? '✏️ Edit Kategori' : '➕ Tambah Kategori' }}
          </h3>
          <button
            @click="showModal = false"
            :class="isDark ? 'bg-slate-800 text-slate-400 hover:text-slate-200' : 'bg-slate-100 text-slate-500 hover:text-slate-700'"
            class="w-8 h-8 flex items-center justify-center rounded-lg text-sm font-black"
          >
            ✕
          </button>
        </div>

        <div v-if="errorMessage" class="p-3 rounded-xl bg-rose-500/10 border border-rose-500/30 text-rose-400 text-xs font-medium">
          {{ errorMessage }}
        </div>

        <form @submit.prevent="saveCategory" class="space-y-4">
          <div>
            <label :class="isDark ? 'text-slate-300' : 'text-slate-700'" class="block text-xs font-semibold mb-1">
              Nama Kategori <span class="text-rose-500">*</span>
            </label>
            <input
              v-model="form.nama_kategori"
              type="text"
              required
              :class="isDark ? 'bg-slate-800 border-slate-700 text-white placeholder-slate-500' : 'bg-slate-50 border-slate-300 text-slate-900'"
              class="w-full px-4 py-2.5 text-xs rounded-xl border focus:ring-2 focus:ring-indigo-500 outline-none transition-colors"
              placeholder="Contoh: Novel Fiksi"
            />
          </div>

          <div :class="isDark ? 'border-slate-800' : 'border-slate-100'" class="flex justify-end gap-3 pt-2 border-t">
            <button
              type="button"
              @click="showModal = false"
              :class="isDark ? 'text-slate-400 hover:bg-slate-800' : 'text-slate-600 hover:bg-slate-100'"
              class="px-4 py-2 text-xs font-semibold rounded-xl transition-colors"
            >
              Batal
            </button>
            <button
              type="submit"
              :disabled="submitting"
              class="px-5 py-2 text-xs font-black text-white bg-indigo-600 hover:bg-indigo-700 rounded-xl shadow-md transition-all disabled:opacity-50 active:scale-95"
            >
              {{ submitting ? 'Menyimpan...' : 'Simpan' }}
            </button>
          </div>
        </form>
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
const categories = ref<any[]>([])
const loading = ref(true)
const showModal = ref(false)
const isEdit = ref(false)
const editId = ref<number | null>(null)
const submitting = ref(false)
const errorMessage = ref('')

const form = reactive({
  nama_kategori: ''
})

const fetchCategories = async () => {
  loading.value = true
  try {
    const res = await api.get('/api/categories')
    categories.value = res.data || []
  } catch (e) {
    console.error(e)
  } finally {
    loading.value = false
  }
}

const openCreateModal = () => {
  isEdit.value = false
  editId.value = null
  form.nama_kategori = ''
  errorMessage.value = ''
  showModal.value = true
}

const openEditModal = (cat: any) => {
  isEdit.value = true
  editId.value = cat.id
  form.nama_kategori = cat.nama_kategori
  errorMessage.value = ''
  showModal.value = true
}

const saveCategory = async () => {
  submitting.value = true
  errorMessage.value = ''

  try {
    if (isEdit.value && editId.value) {
      await api.put(`/api/admin/categories/${editId.value}`, form)
    } else {
      await api.post('/api/admin/categories', form)
    }
    showModal.value = false
    await fetchCategories()
  } catch (err: any) {
    errorMessage.value = err.data?.message || err.data?.errors?.nama_kategori?.[0] || 'Gagal menyimpan kategori'
  } finally {
    submitting.value = false
  }
}

const deleteCategory = async (cat: any) => {
  if (!confirm(`Yakin ingin menghapus kategori '${cat.nama_kategori}'?`)) return
  try {
    await api.delete(`/api/admin/categories/${cat.id}`)
    await fetchCategories()
  } catch (err: any) {
    alert(err.data?.message || 'Gagal menghapus kategori')
  }
}

onMounted(fetchCategories)
</script>
