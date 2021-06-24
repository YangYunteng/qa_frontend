<template>
  <v-container>
    <v-row class="justify-center">
      <v-col cols="5">
        <v-file-input counter chips multiple label="大量数据导入,请导入前缀为spo,entity以及relation的csv文件" ref="file" outlined dense
                      v-model="files" acce></v-file-input>
      </v-col>
      <v-col cols="3">
        <v-btn color="primary" text @click="submitFiles">上传</v-btn>
      </v-col>
    </v-row>
    <v-card v-for="(item,index) in suggestions" :key="index" color="rgb(255,255,255,0.6)" class="mt-2" outlined
            min-height="50px">
      <v-row>
        <v-col cols="5">
          <b>建议提出者: {{ item.suggester_name }}</b>
        </v-col>
        <v-spacer></v-spacer>
        <v-col>
          <v-tooltip bottom>
            <template v-slot:activator="{ on, attrs }">
              <v-icon color="primary" dark v-bind="attrs" v-on="on"
                      @click="openDialog(item,index)"
                      style="cursor: pointer">
                mdi-pencil
              </v-icon>
            </template>
            <span>修改</span>
          </v-tooltip>
        </v-col>
      </v-row>
      <v-row style="margin-top: -20px" class="justify-center">
        <v-col cols="11">
          <p v-html="item.content"></p>
        </v-col>
      </v-row>
      <v-row style="margin-top: -20px">
        <!--        <v-col cols="3">{{ getTime(item.UpdatedAt) }}</v-col>-->
        <v-col cols="3"><b>提交时间</b>: 2021-4-21 12:30:12</v-col>
      </v-row>
    </v-card>
    <div class="text-center" v-if="suggestions.length!=0">
      <v-pagination
        v-model="currPage"
        :length="PaginationLen"
        :total-visible="6"
        @input="querySuggestions"
      ></v-pagination>
    </div>

    <!-- 对回答和评论进行评论的Dialog -->
    <v-dialog transition="dialog-bottom-transition" v-model="isDialogOn" width="900px" persistent>
      <v-card>
        <v-toolbar
          color="primary"
          dark
        >评论
        </v-toolbar>
        <v-card-text class="mt-5">
          <v-textarea color="black" label="评论" v-model="comment"></v-textarea>
          <v-row class="justify-center">
            <v-col cols="12">
              <p>修改方式选择</p>
              <v-btn v-for="(item,index) in operations" :key="index"
                     class="mb-4 mr-4" elevation="2" :color=item.color depressed @click="chooseOperation(index)">
                {{ item.name }}
              </v-btn>
            </v-col>
          </v-row>
          <!-- 添加三元组 -->
          <v-card v-if="operations[0].on">
            <v-row class="justify-center">
              <v-col cols="3">
                <v-text-field v-model="add_spo_subject" label="主语" dense
                              ref="add_spo_subject" outlined></v-text-field>
              </v-col>
              <v-col cols="3">
                <v-text-field v-model="add_spo_predicate" label="谓词" dense
                              ref="add_spo_predicate" outlined></v-text-field>
              </v-col>
              <v-col cols="3">
                <v-text-field v-model="add_spo_object" label="宾语" dense
                              ref="add_spo_object" outlined></v-text-field>
              </v-col>
            </v-row>
            <v-row style="margin-top: -20px">
              <v-col cols="2"><p>将添加的三元组</p></v-col>
              <v-col cols="10">
                <v-chip v-for="(item,index) in add_spo_value" :key="index" close @click:close="deleteAddSPO(index)">
                  {{ item.subject }} {{ item.predicate }} {{ item.spo }}
                </v-chip>
              </v-col>
            </v-row>
            <v-card-actions class="justify-end">
              <v-btn class="mb-4 mr-4" elevation="2" color="primary" depressed @click="addAddSPO">添加</v-btn>
            </v-card-actions>

            <!-- 删除三元组 -->
          </v-card>
          <v-card v-if="operations[1].on">
            <v-row class="justify-center">
              <v-col cols="3">
                <v-text-field v-model="del_spo_subject" label="主语" dense
                              ref="del_spo_subject" outlined></v-text-field>
              </v-col>
              <v-col cols="3">
                <v-text-field v-model="del_spo_predicate" label="谓词" dense
                              ref="del_spo_predicate" outlined></v-text-field>
              </v-col>
              <v-col cols="3">
                <v-text-field v-model="del_spo_object" label="宾语" dense
                              ref="del_spo_object" outlined></v-text-field>
              </v-col>
            </v-row>
            <v-row style="margin-top: -20px">
              <v-col cols="2"><p>将删除的三元组</p></v-col>
              <v-col cols="10">
                <v-chip v-for="(item,index) in del_spo_value" :key="index" close @click:close="deleteDelSPO(index)">
                  {{ item.subject }} {{ item.predicate }} {{ item.spo }}
                </v-chip>
              </v-col>
            </v-row>
            <v-card-actions class="justify-end">
              <v-btn class="mb-4 mr-4" elevation="2" color="primary" depressed @click="addDelSPO">添加</v-btn>
            </v-card-actions>
          </v-card>
          <v-card v-if="operations[2].on">
            <v-row class="justify-center">
              <v-col cols="5">
                <v-text-field v-model="old_primary" label="原主名" dense
                              ref="old_primary" outlined></v-text-field>
              </v-col>
              <v-col cols="5">
                <v-text-field v-model="new_primary" label="新主名" dense
                              ref="new_primary" outlined></v-text-field>
              </v-col>
            </v-row>
          </v-card>
          <!-- 添加别名-->
          <v-card v-if="operations[3].on">
            <v-row class="justify-center">
              <v-col cols="5">
                <v-text-field v-model="add_aliases_primary" label="添加主名" dense
                              ref="add_aliases_primary" outlined></v-text-field>
              </v-col>

              <v-col cols="5">
                <v-text-field v-model="add_aliases_aliase" label="别名" dense
                              ref="add_aliases_aliase" outlined></v-text-field>
              </v-col>
            </v-row>
            <v-row style="margin-top: -20px">
              <v-col cols="2"><p>将添加的别名</p></v-col>
              <v-col cols="10">
                <v-chip v-for="(item,index) in add_aliases_arr" :key="index" close
                        @click:close="deleteAddAliase(index)">
                  {{ item }}
                </v-chip>
              </v-col>
            </v-row>
            <v-card-actions class="justify-end">
              <v-btn class="mb-4 mr-4" elevation="2" color="primary" depressed @click="addAddAliase">添加</v-btn>
            </v-card-actions>
          </v-card>
          <!-- 添加别名-->
          <v-card v-if="operations[4].on">
            <v-row class="justify-center">
              <v-col cols="5">
                <v-text-field v-model="del_aliases_primary" label="删除主名" dense
                              ref="del_aliases_primary" outlined></v-text-field>
              </v-col>

              <v-col cols="5">
                <v-text-field v-model="del_aliases_aliase" label="别名" dense
                              ref="del_aliases_aliase" outlined></v-text-field>
              </v-col>
            </v-row>
            <v-row style="margin-top: -20px">
              <v-col cols="2"><p>将删除的别名</p></v-col>
              <v-col cols="10">
                <v-chip v-for="(item,index) in del_aliases_arr" :key="index" close
                        @click:close="deleteDelAliase(index)">
                  {{ item }}
                </v-chip>
              </v-col>
            </v-row>
            <v-card-actions class="justify-end">
              <v-btn class="mb-4 mr-4" elevation="2" color="primary" depressed @click="addDelAliase">添加</v-btn>
            </v-card-actions>
          </v-card>
          <!-- 添加新对象-->
          <v-card v-if="operations[5].on">
            <v-row class="justify-center">
              <v-col cols="5">
                <v-text-field v-model="add_object_primary" label="新对象主名" dense
                              ref="add_object_primary" outlined></v-text-field>
              </v-col>

              <v-col cols="5">
                <v-text-field v-model="add_object_aliase" label="别名" dense
                              ref="add_object_aliase" outlined></v-text-field>
              </v-col>
            </v-row>
            <v-row style="margin-top: -20px">
              <v-col cols="2"><p>新对象的别名</p></v-col>
              <v-col cols="10">
                <v-chip v-for="(item,index) in add_object_aliases" :key="index" close
                        @click:close="deleteObjAliase(index)">
                  {{ item }}
                </v-chip>
              </v-col>
            </v-row>
            <v-card-actions class="justify-end">
              <v-btn class="mb-4 mr-4" elevation="2" color="primary" depressed @click="addObjAliase">添加</v-btn>
            </v-card-actions>
          </v-card>
          <!-- 删除对象-->
          <v-card v-if="operations[6].on">
            <v-row class="justify-center">
              <v-col cols="6">
                <v-text-field v-model="del_object_primary" label="删除对象主名" dense
                              ref="del_object_primary" outlined></v-text-field>
              </v-col>
            </v-row>
          </v-card>
        </v-card-text>
        <v-card-actions class="justify-end">
          <template v-for="(item,index) in operations">
            <v-btn v-if="item.on" class="mb-4 mr-4" elevation="2" color="primary" :key="index"
                   depressed @click="item.commit">提交{{ item.name }}
            </v-btn>
          </template>
          <v-btn class="mb-4 mr-4" elevation="2" color="primary" depressed @click="closeDialog">取消</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script>
export default {
  name: "Suggestions",
  data() {
    return {
      suggestions: [],
      files: null,
      app: this.$root.$children[0],
      currPage: 1,
      PaginationLen: 1,
      pageSize: 5,
      comment: '',
      suggestion: {},
      suggestionID: 0,
      isDialogOn: false,
      isOperated: false,
      operations: [
        {name: '添加三元组', on: false, color: 'primary', commit: this.commit_spo_add},
        {name: '删除三元组', on: false, color: "error", commit: this.commit_spo_del},
        {name: '替换主名', on: false, color: 'primary', commit: this.commit_replace_primary},
        {name: '添加别名', on: false, color: 'warning', commit: this.commit_add_aliases},
        {name: '删除别名', on: false, color: 'error', commit: this.commit_del_aliases},
        {name: '增加实体类', on: false, color: 'primary', commit: this.commit_add_primary_aliases},
        {name: '删除实体类', on: false, color: 'error', commit: this.commit_del_primary_aliases}
      ],
      //添加三元组
      add_spo_subject: '',
      add_spo_predicate: '',
      add_spo_object: '',
      add_spo_value: [],
      //删除三元组
      del_spo_subject: '',
      del_spo_predicate: '',
      del_spo_object: '',
      del_spo_value: [],
      //替换主名
      old_primary: '',
      new_primary: '',
      //添加别名
      add_aliases_primary: '',
      add_aliases_aliase: '',
      add_aliases_arr: [],
      //删除别名
      del_aliases_primary: '',
      del_aliases_aliase: '',
      del_aliases_arr: [],
      //添加实体类
      add_object_primary: '',
      add_object_aliase: '',
      add_object_aliases: [],
      //删除实体类
      del_object_primary: '',
    }
  },
  mounted() {

  },
  methods: {
    submitFiles() {
      let formData = new FormData()
      if (this.files) {
        for (let file of this.files) {
          formData.append("files", file, file.name);
        }
        this.$axios.post('/adminServer/admin/upload', formData).then(resp => {
          if (resp.data.code===200) {
            this.app.message('数据导入成功', "success");
          } else {
            this.app.message('数据导入失败，请注意文件格式', 'warning')
          }
          console.log(resp)
        }).catch(error => {
          console.log(error)
        })
      } else {
        this.app.message("请选择相关文件", 'warning');
      }
    },
    chooseOperation: function (index) {
      for (let i = 0; i < this.operations.length; i++) {
        this.$set(this.operations[i], "on", false);
      }
      this.$set(this.operations[index], "on", true);
    },

    //添加三元组
    addAddSPO: function () {
      if (this.add_spo_object === '' || this.add_spo_subject === '' || this.add_spo_predicate === '')
        return;
      let value = {
        "subject": this.add_spo_subject,
        "predicate": this.add_spo_predicate,
        "object": this.add_spo_object
      };
      this.add_spo_value.push(value);
      this.add_spo_object = '';
      this.add_spo_subject = '';
      this.add_spo_predicate = '';
    },

    deleteAddSPO: function (index) {
      this.add_spo_value.splice(index, 1);
    },

    commit_spo_add: function () {
      if (this.comment === '') {
        this.app.message("评论不能为空", 'warning');
        return;
      }
      if (this.add_spo_value.length === 0) {
        this.app.message('未添加三元组', 'warning');
        return;
      }
      let commit = {};
      commit.col_names = [
        "entity",
        "relation",
        "spo"
      ];
      commit.operation = "add_spo";
      commit.value = this.add_spo_value;
      let commands = [];
      commands.push(commit);
      let path = '/adminServer/admin/commit';
      this.$axios.post(path,
        {
          "commands": commands,
          "comment": this.comment,
          "suggester_id": this.suggestion.suggester_id + ""
        }).then(resp => {
        if (resp.data.code === 200) {
          this.app.message("修改成功", 'success');
        } else {
          this.app.message("修改失败", 'error');
        }
      }).catch(() => {
        this.app.message("服务器在忙", 'red');
      })
    },
    openDialog: function (item, index) {
      this.suggestion = item;
      this.isDialogOn = true;
    },
    closeDialog: function () {
      this.isDialogOn = false;
      //添加三元组
      this.comment = '';
      this.add_spo_subject = '';
      this.add_spo_predicate = '';
      this.add_spo_object = '';
      this.add_spo_value = [];
      //删除三元组
      this.del_spo_subject = '';
      this.del_spo_predicate = '';
      this.del_spo_object = '';
      this.del_spo_value = [];
      //替换主名
      this.old_primary = '';
      this.new_primary = '';
      //添加别名
      this.add_aliases_primary = '';
      this.add_aliases_aliase = '';
      this.add_aliases_arr = [];
      //删除别名
      this.del_aliases_primary = '';
      this.del_aliases_aliase = '';
      this.del_aliases_arr = [];
      //添加实体类
      this.add_object_primary = '';
      this.add_object_aliase = '';
      this.add_object_aliases = [];
      //删除实体类
      this.del_object_primary = '';
    },

    //删除三元组
    addDelSPO: function () {
      if (this.del_spo_object === '' || this.del_spo_subject === '' || this.del_spo_predicate === '')
        return;
      let value = {
        "subject": this.del_spo_subject,
        "predicate": this.del_spo_predicate,
        "object": this.del_spo_object
      };
      this.del_spo_value.push(value);
      this.del_spo_object = '';
      this.del_spo_subject = '';
      this.del_spo_predicate = '';
    },
    deleteDelSPO: function (index) {
      this.del_spo_value.splice(index, 1);
    },

    commit_spo_del: function () {
      if (this.comment === '') {
        this.app.message("评论不能为空", 'warning');
        return;
      }
      if (this.del_spo_value.length === 0) {
        this.app.message('未添加三元组', 'warning');
        return;
      }
      let commit = {};
      commit.col_names = [
        "entity",
        "relation",
        "spo"
      ];
      commit.operation = "del_spo";
      commit.value = this.del_spo_value;
      let commands = [];
      commands.push(commit);
      let path = '/adminServer/admin/commit';
      this.$axios.post(path,
        {
          "commands": commands,
          "comment": this.comment,
          "suggester_id": this.suggestion.suggester_id + ""
        }).then(resp => {
        if (resp.data.code === 200) {
          this.app.message("修改成功", 'success');
        } else {
          this.app.message("修改失败", 'warning');
        }
      }).catch(() => {
        this.app.message("服务器在忙", 'red');
      })
    },

    //替换主名
    commit_replace_primary: function () {
      if (this.comment === '') {
        this.app.message("评论不能为空", 'warning');
        return;
      }
      if (this.old_primary === '' || this.new_primary === '') {
        this.app.message("主名未全部填写", 'warning');
        return;
      }
      let commands = [];
      let command = {};
      command.col_names = [
        "entity"
      ];
      command.operation = "replace_primary";
      command.value = {
        "old": this.old_primary,
        "new": this.new_primary
      }
      commands.push(command)
      let path = '/adminServer/admin/commit';
      this.$axios.post(path, {
        "commands": commands,
        "comment": this.comment,
        "suggester_id": this.suggestion.suggester_id + "",
      }).then(resp => {
        if (resp.data.code === 200) {
          this.app.message("修改成功", 'success');
        } else {
          this.app.message("修改失败", "warning");
        }
      }).catch(() => {
        this.app.message('服务器在忙', 'red');
      })
    },

    //添加别名
    deleteAddAliase: function (index) {
      this.add_aliases_arr.splice(index, 1);
    },
    addAddAliase: function () {
      if (this.add_aliases_aliase === '')
        return;
      this.add_aliases_arr.push(this.add_aliases_aliase);
      this.add_aliases_aliase = '';
    },
    commit_add_aliases: function () {
      if (this.comment === '') {
        this.app.message("评论不能为空", 'warning');
        return;
      }
      if (this.add_aliases_primary === '' || this.add_aliases_arr.length === 0) {
        this.app.message("主名或别名未填写", 'warning');
        return;
      }
      let commands = [];
      let command = {};
      command.col_names = [
        "entity"
      ];
      command.operation = "add_aliases";
      command.value = {
        "primary": this.add_aliases_primary,
        "aliases": this.add_aliases_arr
      }
      commands.push(command)
      let path = '/adminServer/admin/commit';
      this.$axios.post(path, {
        "commands": commands,
        "comment": this.comment,
        "suggester_id": this.suggestion.suggester_id + "",
      }).then(resp => {
        if (resp.data.code === 200) {
          this.app.message("修改成功", 'success');
        } else {
          this.app.message("修改失败", 'warning');
        }
      }).catch(() => {
        this.app.message('服务器在忙', 'red');
      })
    },

    //删除别名
    deleteDelAliase: function (index) {
      this.del_aliases_arr.splice(index, 1);
    },
    addDelAliase: function () {
      if (this.del_aliases_aliase === '')
        return;
      this.del_aliases_arr.push(this.del_aliases_aliase);
      this.del_aliases_aliase = '';
    },

    commit_del_aliases: function () {
      if (this.comment === '') {
        this.app.message("评论不能为空", 'warning');
        return;
      }
      if (this.del_aliases_primary === '' || this.del_aliases_arr.length === 0) {
        this.app.message("主名或别名未填写", 'warning');
        return;
      }
      let commands = [];
      let command = {};
      command.col_names = [
        "entity"
      ];
      command.operation = "del_aliases";
      command.value = {
        "primary": this.del_aliases_primary,
        "aliases": this.del_aliases_arr
      }
      commands.push(command)
      let path = '/adminServer/admin/commit';
      this.$axios.post(path, {
        "commands": commands,
        "comment": this.comment,
        "suggester_id": this.suggestion.suggester_id + "",
      }).then(resp => {
        if (resp.data.code === 200) {
          this.app.message("修改成功", 'success');
        } else {
          this.app.message("修改失败", 'warning');
        }
      }).catch(() => {
        this.app.message('服务器在忙', 'red');
      })
    },

    //新增对象
    deleteObjAliase: function (index) {
      this.add_object_aliases.splice(index, 1);
    },

    addObjAliase: function () {
      if (this.add_object_aliase === '')
        return;
      this.add_object_aliases.push(this.add_object_aliase);
      this.add_object_aliase = '';
    },

    commit_add_primary_aliases: function () {
      if (this.comment === '') {
        this.app.message("评论不能为空", 'warning');
        return;
      }
      if (this.add_object_primary === '' || this.add_object_aliases.length === 0) {
        this.app.message("主名或别名未填写", 'warning');
        return;
      }
      let commands = [];
      let command = {};
      command.col_names = [
        "entity"
      ];
      command.operation = "add_primary_aliases";
      command.value = {
        "primary": this.add_object_primary,
        "aliases": this.add_object_aliases
      }
      commands.push(command)
      let path = '/adminServer/admin/commit';
      this.$axios.post(path, {
        "commands": commands,
        "comment": this.comment,
        "suggester_id": this.suggestion.suggester_id + "",
      }).then(resp => {
        if (resp.data.code === 200) {
          this.app.message("修改成功", 'success');
        } else {
          this.app.message("修改失败", 'warning');
        }
      }).catch(() => {
        this.app.message('服务器在忙', 'red');
      })
    },

    commit_del_primary_aliases: function () {
      if (this.comment === '') {
        this.app.message("评论不能为空", 'warning');
        return;
      }
      if (this.del_object_primary === '') {
        this.app.message("主名未填写", 'warning');
        return;
      }
      let commands = [];
      let command = {};
      command.col_names = [
        "entity"
      ];
      command.operation = "del_primary_aliases";
      command.value = this.del_object_primary;
      commands.push(command)
      let path = '/adminServer/admin/commit';
      this.$axios.post(path, {
        "commands": commands,
        "comment": this.comment,
        "suggester_id": this.suggestion.suggester_id + "",
      }).then(resp => {
        if (resp.data.code === 200) {
          this.app.message("修改成功", 'success');
        } else {
          this.app.message("修改失败", 'warning');
        }
      }).catch(() => {
        this.app.message('服务器在忙', 'red');
      })
    },
    getTime: function (date) {
      date = new Date(date);
      let res = '';
      res += date.getFullYear() + '-';
      res += this.timeComplement(date.getMonth() + 1, 2) + '-';
      res += this.timeComplement(date.getDate(), 2) + ' ';
      res += this.timeComplement(date.getHours(), 2) + ':';
      res += this.timeComplement(date.getMinutes(), 2) + ':';
      res += this.timeComplement(date.getSeconds(), 2);
      return res;
    },

    querySuggestions: function () {
      let pageNum = parseInt(this.pageNum);
      let pageSize = parseInt(this.pageSize);
      let path = '/adminServer/admin/suggestions';
      this.app.overlay = true;
      this.$axios.get(path, {
        params: {
          pageNum: this.currPage,
          pageSize: this.pageSize,
        }
      }).then(resp => {
        console.log(resp);
        if (resp.data.code === 200) {
          if (resp.data.data != null) {
            for (let temp of resp.data.data) {
              let suggestion = {};
              suggestion.content = temp.content;
              suggestion.updated_at = temp.updated_at;
              suggestion.created_at = temp.created_at;
              suggestion.suggester_id = temp.user_id;
              this.suggestions.push(suggestion);
            }
            for (let i = 0; i < this.suggestions.length; i++) {
              let path = '/userServer/users/' + this.suggestions[i].suggester_id;
              this.$axios.get(path, {}).then(resp => {
                if (resp.data.code === 200) {
                  this.$set(this.suggestions[i], 'suggester_name', resp.data.data.nickname);
                } else {
                  this.$set(this.suggestions[i], 'suggester_name', '未知');
                }
              }).catch(error => {
                console.log(error);
              })
            }
          } else {
            this.app.message('尚未有意见', 'warning');
          }
        }
        this.app.overlay = false;
      }).catch(() => {
        this.app.message("服务器在忙", 'red');
      })
    }
  }
}

</script>

<style scoped>

</style>
