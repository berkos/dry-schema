RSpec.describe 'Predicates: Type' do
  context 'with required' do
    subject(:schema) do
      Dry::Schema.form do
        required(:foo, :int) { type?(Integer) }
      end
    end

    context 'with valid input' do
      let(:input) { { 'foo' => '23' } }

      it 'is successful' do
        expect(result).to be_successful
      end
    end

    context 'with missing input' do
      let(:input) { {} }

      it 'is not successful' do
        expect(result).to be_failing ['is missing', 'must be Integer']
      end
    end

    context 'with nil input' do
      let(:input) { { 'foo' => nil } }

      it 'is not successful' do
        expect(result).to be_failing ['must be Integer']
      end
    end

    context 'with blank input' do
      let(:input) { { 'foo' => '' } }

      it 'is not successful' do
        expect(result).to be_failing ['must be Integer']
      end
    end

    context 'with invalid type' do
      let(:input) { { 'foo' => ['x'] } }

      it 'is not successful' do
        expect(result).to be_failing ['must be Integer']
      end
    end
  end

  context 'with optional' do
    subject(:schema) do
      Dry::Schema.form do
        optional(:foo, :int) { type?(Integer) }
      end
    end

    context 'with valid input' do
      let(:input) { { 'foo' => '23' } }

      it 'is successful' do
        expect(result).to be_successful
      end
    end

    context 'with missing input' do
      let(:input) { {} }

      it 'is successful' do
        expect(result).to be_successful
      end
    end

    context 'with nil input' do
      let(:input) { { 'foo' => nil } }

      it 'is not successful' do
        expect(result).to be_failing ['must be Integer']
      end
    end

    context 'with blank input' do
      let(:input) { { 'foo' => '' } }

      it 'is not successful' do
        expect(result).to be_failing ['must be Integer']
      end
    end

    context 'with invalid type' do
      let(:input) { { 'foo' => ['x'] } }

      it 'is not successful' do
        expect(result).to be_failing ['must be Integer']
      end
    end
  end

  context 'as macro' do
    context 'with required' do
      context 'with value' do
        subject(:schema) do
          Dry::Schema.form do
            required(:foo, :int).value(type?: Integer)
          end
        end

        context 'with valid input' do
          let(:input) { { 'foo' => '23' } }

          it 'is successful' do
            expect(result).to be_successful
          end
        end

        context 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            expect(result).to be_failing ['is missing', 'must be Integer']
          end
        end

        context 'with nil input' do
          let(:input) { { 'foo' => nil } }

          it 'is not successful' do
            expect(result).to be_failing ['must be Integer']
          end
        end

        context 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is not successful' do
            expect(result).to be_failing ['must be Integer']
          end
        end

        context 'with invalid type' do
          let(:input) { { 'foo' => ['x'] } }

          it 'is not successful' do
            expect(result).to be_failing ['must be Integer']
          end
        end
      end

      context 'with filled' do
        subject(:schema) do
          Dry::Schema.form do
            required(:foo, :int).filled(type?: Integer)
          end
        end

        context 'with valid input' do
          let(:input) { { 'foo' => '23' } }

          it 'is successful' do
            expect(result).to be_successful
          end
        end

        context 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            expect(result).to be_failing ['is missing', 'must be Integer']
          end
        end

        context 'with nil input' do
          let(:input) { { 'foo' => nil } }

          it 'is not successful' do
            expect(result).to be_failing ['must be filled', 'must be Integer']
          end
        end

        context 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is not successful' do
            expect(result).to be_failing ['must be filled', 'must be Integer']
          end
        end

        context 'with invalid type' do
          let(:input) { { 'foo' => ['x'] } }

          it 'is not successful' do
            expect(result).to be_failing ['must be Integer']
          end
        end
      end

      context 'with maybe' do
        subject(:schema) do
          Dry::Schema.form do
            required(:foo, [:nil, :int]).maybe(type?: Integer)
          end
        end

        context 'with valid input' do
          let(:input) { { 'foo' => '23' } }

          it 'is successful' do
            expect(result).to be_successful
          end
        end

        context 'with missing input' do
          let(:input) { {} }

          it 'is not successful' do
            expect(result).to be_failing ['is missing', 'must be Integer']
          end
        end

        context 'with nil input' do
          let(:input) { { 'foo' => nil } }

          it 'is successful' do
            expect(result).to be_successful
          end
        end

        context 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is successful' do
            expect(result).to be_successful
          end
        end

        context 'with invalid type' do
          let(:input) { { 'foo' => ['x'] } }

          it 'is not successful' do
            expect(result).to be_failing ['must be Integer']
          end
        end
      end
    end

    context 'with optional' do
      context 'with value' do
        subject(:schema) do
          Dry::Schema.form do
            optional(:foo, :int).value(type?: Integer)
          end
        end

        context 'with valid input' do
          let(:input) { { 'foo' => '23' } }

          it 'is successful' do
            expect(result).to be_successful
          end
        end

        context 'with missing input' do
          let(:input) { {} }

          it 'is successful' do
            expect(result).to be_successful
          end
        end

        context 'with nil input' do
          let(:input) { { 'foo' => nil } }

          it 'is not successful' do
            expect(result).to be_failing ['must be Integer']
          end
        end

        context 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is not successful' do
            expect(result).to be_failing ['must be Integer']
          end
        end

        context 'with invalid type' do
          let(:input) { { 'foo' => ['x'] } }

          it 'is not successful' do
            expect(result).to be_failing ['must be Integer']
          end
        end
      end

      context 'with filled' do
        subject(:schema) do
          Dry::Schema.form do
            optional(:foo, :int).filled(type?: Integer)
          end
        end

        context 'with valid input' do
          let(:input) { { 'foo' => '23' } }

          it 'is successful' do
            expect(result).to be_successful
          end
        end

        context 'with missing input' do
          let(:input) { {} }

          it 'is successful' do
            expect(result).to be_successful
          end
        end

        context 'with nil input' do
          let(:input) { { 'foo' => nil } }

          it 'is not successful' do
            expect(result).to be_failing ['must be filled', 'must be Integer']
          end
        end

        context 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is not successful' do
            expect(result).to be_failing ['must be filled', 'must be Integer']
          end
        end

        context 'with invalid type' do
          let(:input) { { 'foo' => ['x'] } }

          it 'is not successful' do
            expect(result).to be_failing ['must be Integer']
          end
        end
      end

      context 'with maybe' do
        subject(:schema) do
          Dry::Schema.form do
            optional(:foo, [:nil, :int]).maybe(type?: Integer)
          end
        end

        context 'with valid input' do
          let(:input) { { 'foo' => '23' } }

          it 'is successful' do
            expect(result).to be_successful
          end
        end

        context 'with missing input' do
          let(:input) { {} }

          it 'is successful' do
            expect(result).to be_successful
          end
        end

        context 'with nil input' do
          let(:input) { { 'foo' => nil } }

          it 'is successful' do
            expect(result).to be_successful
          end
        end

        context 'with blank input' do
          let(:input) { { 'foo' => '' } }

          it 'is successful' do
            expect(result).to be_successful
          end
        end

        context 'with invalid type' do
          let(:input) { { 'foo' => ['x'] } }

          it 'is not successful' do
            expect(result).to be_failing ['must be Integer']
          end
        end
      end
    end
  end
end
